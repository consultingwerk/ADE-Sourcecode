/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : hdaniels
   Created     : July 2013 
   Notes       : 
 ----------------------------------------------------------------------*/
 
block-level on error undo, throw. 
 
using OpenEdge.DataAdmin.DataAccess.DataAccess from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.DataSource.FieldPartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.IDataSource from propath.
using OpenEdge.DataAdmin.DataSource.IndexDataReader from propath.
using OpenEdge.DataAdmin.DataSource.IndexDataSource from propath.
using OpenEdge.DataAdmin.DataSource.IndexPartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.LocalIndexDataSource from propath.
using OpenEdge.DataAdmin.DataSource.PartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.PartitionPolicyDataSource from propath.
using OpenEdge.DataAdmin.DataSource.PartitionPolicyDetailDataSource from propath.
using OpenEdge.DataAdmin.DataSource.PartitionPolicyFieldDataSource from propath.
using OpenEdge.DataAdmin.Error.IllegalOperationError from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Message.ITableRequest from propath.
using Progress.Lang.Error from propath.

class OpenEdge.DataAdmin.DataAccess.PartitionPolicyData inherits DataAccess : 
    
    	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	constructor public PartitionPolicyData (  ):
		super ().
		
		/* Maybe a questionable place to throw an error, but this is a nicer error than the 
		   inevitable ABL error that will be thrown when attempting to save or fetch to one of 
		   the datasources that reference the policy table. The check could alternatively be
		   done in save and fetch, but any operation is illegal. */
		if not DatabaseInfo:IsPartitionEnabled then
		    undo, throw new IllegalOperationError("The database is not enabled for horizontal partitioning.").
		    
	end constructor.

    /** @todo remove and use dataaccess dynamic new ?
        NOTE: As of current not all datasources are prepared to save(buffer,row-state)
              which these need to do, so don't add new ones without fixing them */
    method protected override IDataSource CreateSaveSource(pcName as char):
        case pcName: 
           when "ttPartitionPolicy" then
               return new PartitionPolicyDataSource().
           when "ttPartitionPolicyDetail" then
               return new PartitionPolicyDetailDataSource().
           when "ttPartitionPolicyField" then
               return new PartitionPolicyFieldDataSource().
           when "ttPartition" then
               return new PartitionDataSource().
           when "ttLocalIndex" then
               return new LocalIndexDataSource().
           otherwise 
               return super:CreateSaveSource(pcname).   
        end case.
    end method.
    
    method protected override void SaveBuffers(phDataset as handle):
         define variable datasource as IDataSource no-undo.
         define variable hbuffer    as handle no-undo.
         super:SaveBuffers(phDataset).
         hbuffer = phDataset:get-buffer-handle ("ttPartitionPolicy").
         if valid-handle(hbuffer) then
         do:
             datasource = GetSaveSource("ttPartitionPolicy").
             datasource:Refresh(hBuffer).
         end.  
    end method.    
        
    method public override void FetchData(msg as IFetchRequest): 
        Url = msg:url.
        DatasetHandle = msg:DataHandle.       
        FillData(msg).
    end method.
    
    method public void FillNewDetails(hBuffer as handle,pcQuery as char ):
        define variable indexDataReader as IndexDataReader no-undo.    
        indexDataReader = new IndexDataReader().
        indexDataReader:FillMode = "Append".
        indexDataReader:Prepare(hBuffer,pcQuery,"").
        indexDataReader:Fill().    
    end.
    
    method public void FillData(msg as IFetchRequest):
        define variable hPartitionPolicyBuffer as handle no-undo.
        define variable detailSource as IDataSource no-undo.
        define variable PartitionPolicySource as IDataSource no-undo.
        define variable PartitionPolicyFieldSource as IDataSource no-undo.
        define variable localindexSource  as IDataSource no-undo.
        define variable tableRequest as ITableRequest no-undo.     
        define variable hPolicyDetail  as handle no-undo.
        define variable hPolicyField  as handle no-undo.
        define variable hPartition as handle no-undo.
        define variable hindex as handle no-undo.
        define variable lChildBatch  as logical no-undo.
        define variable i as integer no-undo.
        define variable hBuff as handle no-undo.
        define variable cc as character no-undo.
        hPolicyDetail = msg:DataHandle:get-buffer-handle ("ttPartitionPolicyDetail").
        
        if valid-handle(hPolicyDetail) then
        do:
             if msg:GetTableRequestType("ttPartitionPolicyDetail") = "NEW" then
             do:
                 tableRequest = msg:GetTableRequest("ttPartitionPolicyDetail").
                 FillNewDetails(hPolicyDetail,tableRequest:QueryString).
                 return.   
             end. 
    
             hPartitionPolicyBuffer = msg:DataHandle:get-buffer-handle ("ttPartitionPolicy").
              
             if valid-handle(hPolicyDetail:parent-relation) or not valid-handle(hPartitionPolicyBuffer) then
             do:
                 
                 detailSource = new PartitionPolicyDetailDataSource().
                 detailSource:FillMode = "Replace".
                 detailSource:Url = URL.
                 
                 tableRequest = msg:GetTableRequest("ttPartitionPolicyDetail").
                 
                 if valid-handle(hPolicyDetail:parent-relation) and tableRequest:Start > 0 then
                 do:
                     lChildBatch = true.
                     hPolicyDetail:fill-mode = "No-fill".
                 end.
                 else do:                    
                     if valid-object(tableRequest) then 
                         detailSource:Prepare(hPolicyDetail,tableRequest).         
                     else
                         detailSource:Prepare(hPolicyDetail).            
                 end.
             end.
             else do:
                 /* used to map in detail, so start first */
                 PartitionPolicySource = new PartitionPolicyDataSource().   
                 PartitionPolicySource:FillMode = "Replace".
                 PartitionPolicySource:Url = URL.
                 /* PartitionPolicy critera is added to parent detail */
                 PartitionPolicySource:Prepare(hPartitionPolicyBuffer).      
                 detailSource = new PartitionPolicyDetailDataSource().
                 detailSource:FillMode = "Append".
                 detailSource:Url = URL.
                 
                 /* get PartitionPolicy critera (join with detail) and add to parent detail */
                 tableRequest = msg:GetTableRequest("ttPartitionPolicy").
                 
                 if valid-object(tableRequest) then 
                     detailSource:Prepare(hPolicyDetail,tableRequest).         
                 else
                     detailSource:Prepare(hPolicyDetail).            
             
                 
             end.      
        end.
        
        if not valid-object(PartitionPolicySource) then
        do:
            hPartitionPolicyBuffer = msg:DataHandle:get-buffer-handle ("ttPartitionPolicy").
                
            if valid-handle(hPartitionPolicyBuffer) then
            do:
      
                PartitionPolicySource = new PartitionPolicyDataSource().   
                PartitionPolicySource:FillMode = "Replace".
                PartitionPolicySource:Url = URL.
            
                tableRequest = msg:GetTableRequest("ttPartitionPolicy").
      
                if valid-object(tableRequest) then 
                    PartitionPolicySource:Prepare(hPartitionPolicyBuffer,tableRequest).         
                else
                    PartitionPolicySource:Prepare(hPartitionPolicyBuffer).            
            end.             
        end.
        hIndex = msg:DataHandle:get-buffer-handle ("ttLocalIndex").
        if valid-handle(hIndex) then
        do:
  
            localIndexSource = new LocalIndexDataSource().   
            localIndexSource:FillMode = "Append".
            localIndexSource:Url = URL.
            tableRequest = msg:GetTableRequest("ttIndex").
  
            if valid-object(tableRequest) then 
                localIndexSource:Prepare(hIndex,tableRequest).         
            else
                localIndexSource:Prepare(hIndex).            
        end. 
              
        hPolicyField = msg:DataHandle:get-buffer-handle ("ttPartitionPolicyField").
        if valid-handle(hPolicyField) then
        do:
            /* The field list needed to build the partitionPolictfields are
               stored in an extent in the partitionpolicy table. (nice...)
               if the partitionpolicy is in this request there is a 
               beforefill method that will grab the fields from the the ttPartitioPolicyfield
            */

            PartitionPolicyFieldSource = new PartitionPolicyFieldDataSource().   
            PartitionPolicyFieldSource:FillMode = "Append".
            PartitionPolicyFieldSource:Url = URL.
            tableRequest = msg:GetTableRequest("ttPartitionPolicyField").
  
            if valid-object(tableRequest) then 
                PartitionPolicyFieldSource:Prepare(hPolicyField,tableRequest).         
            else
                PartitionPolicyFieldSource:Prepare(hPolicyField).            
            /* if the partitionpolicy is not part of this request the 
               partitionpolicyfieldsource query is actually defined on PartitionPolicy table ]
               (there is no partitionpolicyfield table - only an extent in the partitionpolicy )
               and there is a fill method that will open the query and then build the fields from the 
               field extent  */
            
            if not valid-object(PartitionPolicySource) then do:
                PartitionPolicyFieldSource:Fill().
                PartitionPolicyFieldSource:fillMode = "no-fill".
            end.     
        end.                                   
        
        hPartition = msg:DataHandle:get-buffer-handle ("ttPartition").
        if valid-handle(hPartition) then
        do:
            hPartition:fill-mode = "no-fill".
        end.
    
        DatasetHandle:Fill().
    
        if lChildBatch then
        do: 
            do i = 1 to msg:DataHandle:num-buffers:
                hBuff = msg:DataHandle:get-buffer-handle (i).    
                if hBuff:name = "ttPartitionPolicyDetail" then
                do:
                    tableRequest = msg:GetTableRequest("ttPartitionPolicyDetail").
                    detailSource:Prepare(hPolicyDetail,tableRequest). 
                    detailSource:FillMode = "Append".   
                end.
                else 
                   hBuff:fill-mode = "no-fill".
            end.
            DatasetHandle:Fill().
        end.
           
        if valid-handle(hPartition) then
            fillPartitions(msg).
             
        if valid-object(PartitionPolicySource) then
        do:
            if PartitionPolicySource:NumRecords <> ? then 
                msg:SetTableTotal("ttPartitionPolicy",PartitionPolicySource:NumRecords).
        
        end.
        else if valid-object(detailSource) then
        do:
            if detailSource:NumRecords <> ? then 
                msg:SetTableTotal("ttPartitionPolicyDetail",detailSource:NumRecords).
        
        end.
        /* no GC - must delete - due to dataset event callback*/
        finally: 
            delete object detailSource no-error.   
            delete object localIndexSource no-error.   
            delete object PartitionPolicySource no-error.	 
            delete object PartitionPolicyFieldSource no-error.      	
        end finally. 
    end method. 
    
    method private void fillPartitions(msg as IFetchRequest) :
        define variable i as integer no-undo. 
        define variable hParent    as handle no-undo.
        define variable hPartition as handle no-undo.
        define variable hBuffer    as handle no-undo. 
        define variable cjoin as character no-undo.
       
        define variable partitionSource as IDataSource no-undo.
        define variable indexPartitionSource as IDataSource no-undo.
        define variable fieldPartitionSource as IDataSource no-undo.
        define variable tableRequest as ITableRequest no-undo.     
        define variable cQuery as character no-undo.
       
        do i = 1 to DatasetHandle:num-buffers:
            hbuffer = DatasetHandle:get-buffer-handle(i).
            if hbuffer:name <> "ttPartition" then
            do:
                hbuffer:fill-mode = "no-fill".
                if hBuffer:name = "ttPartitionPolicyDetail" then
                   hParent = hBuffer.
            end.
            else do:
                hPartition = hBuffer.
                hPartition:parent-relation:active  = false.
                hPartition:fill-mode = "Append".
            end.                   
        end.    
       
        tableRequest = msg:GetTableRequest("ttPartition").
        cJoin = "where _StorageObject._object-type = 1 "
              + " and _StorageObject._object-number = ttPartitionPolicyDetail.ObjectNumber "
              + " and _StorageObject._PartitionId   = ttPartitionPolicyDetail.Id ".

        partitionSource = new PartitionDataSource(hParent,
                                            "for each ttPartitionPolicyDetail,"
                                            + " each _storageObject " + cjoin + " no-lock").
        partitionSource:FillMode = "Append".
       
        partitionSource:Url = Url.
       
        if valid-object(tableRequest) then 
            partitionSource:Prepare(hPartition,tableRequest).         
        else
            partitionSource:Prepare(hPartition).            
       
        partitionSource:Prepare(hPartition,cQuery,"").
        DatasetHandle:Fill().

        indexPartitionSource = new IndexPartitionDataSource(hParent,
                                     "_file._File-number = ttPartitionPolicyDetail.ObjectNumber",
                                     "_StorageObject._PartitionId = ttPartitionPolicyDetail.Id").
        indexPartitionSource:FillMode = "Append".
        indexPartitionSource:Url = Url.
        if valid-object(tableRequest) then 
            indexPartitionSource:Prepare(hPartition,tableRequest).         
        else
            indexPartitionSource:Prepare(hPartition).            
       
        DatasetHandle:Fill().
 
        fieldPartitionSource = new FieldPartitionDataSource(hParent,
                                     "_file._File-number = ttPartitionPolicyDetail.ObjectNumber",
                                     "_StorageObject._PartitionId = ttPartitionPolicyDetail.Id"  ).
        fieldPartitionSource:FillMode = "Append".
        fieldPartitionSource:Url = Url.
        if valid-object(tableRequest) then 
            fieldPartitionSource:Prepare(hPartition,tableRequest).         
        else
            fieldPartitionSource:Prepare(hPartition).            
       
        DatasetHandle:Fill().
        hPartition:fill-mode = "no-fill".
        /* no GC - must delete due to dataset event callback*/
        finally: 
            delete object partitionSource no-error.     
            delete object indexPartitionSource no-error.     
            delete object fieldPartitionSource no-error.     		
        end finally.
    end method.
      
    method protected override Error ClientTransactionError(e as Error):
        define variable i as integer no-undo.
        define variable lf as character no-undo init "~n".
        define variable cMsg as character no-undo.
        define variable ltrans as logical no-undo.
        do i = 1 to e:numMessages:
            case e:GetMessageNum(i):
                when 17578 then 
                do:
                    cMsg = (if i = 1 then "" else cmsg + lf ) 
                         + replace(e:GetMessage(i),"_Partition-policy-detail","PartitionPolicyDetail")  + "."  . 
                    lTrans = true.      
                end.                   
                when 17576 then
                do:
                     cMsg = (if i = 1 then "" else cMsg + lf)
                          + replace(e:GetMessage(i),"_Partition-policy-details","PartitionPolicyDetails")  + "."  . 
                     lTrans = true.       
                end.            
                otherwise do:
                     cMsg = (if i = 1 then "" else cMsg + lf)
                          +  e:GetMessage(i).  
                             
                end.            
            end.          
        end.   
        /* if message transformed or more than one wrap it  */ 
        if lTrans or e:numMessages > 1 then 
             return new DataAccessError(cmsg,e).
        return e.
    end method.    
end class.
