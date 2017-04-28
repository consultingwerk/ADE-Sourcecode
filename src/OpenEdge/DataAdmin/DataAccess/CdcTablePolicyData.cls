 /*************************************************************/
 /* Copyright (c) 2015-2016 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 
 /*------------------------------------------------------------------------
    File        : CdcTablePolicyData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Tue Dec 01 20:17:01 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.DataAccess.DataAccess from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.DataSource.FieldPartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.IDataSource from propath.
using OpenEdge.DataAdmin.DataSource.IndexDataReader from propath.
using OpenEdge.DataAdmin.DataSource.IndexDataSource from propath.
using OpenEdge.DataAdmin.DataSource.IndexPartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.LocalIndexDataSource from propath.
using OpenEdge.DataAdmin.DataSource.PartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.CdcTablePolicyDataSource from propath.
using OpenEdge.DataAdmin.DataSource.CdcFieldPolicyDataSource from propath.
//using OpenEdge.DataAdmin.DataSource.CdcTablePolicyFieldDataSource from propath. 
using OpenEdge.DataAdmin.Error.IllegalOperationError from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Message.ITableRequest from propath.
using Progress.Lang.Error from propath.

block-level on error undo, throw.

class OpenEdge.DataAdmin.DataAccess.CdcTablePolicyData inherits DataAccess: 
    
    constructor public CdcTablePolicyData (  ):
        super ().
        
        /* Maybe a questionable place to throw an error, but this is a nicer error than the 
           inevitable ABL error that will be thrown when attempting to save or fetch to one of 
           the datasources that reference the policy table. The check could alternatively be
           done in save and fetch, but any operation is illegal. */
        if not DatabaseInfo:IsCDCEnabled then
            undo, throw new IllegalOperationError("The database is not enabled for Change Data Capture.").
            
    end constructor.
    
    method protected override IDataSource CreateSaveSource(pcName as char):
        case pcName: 
           when "ttCdcTablePolicy" then
               return new CdcTablePolicyDataSource().
           when "ttCdcFieldPolicy" then
               return new CdcFieldPolicyDataSource(). 
           /*when "ttCdcTablePolicyField" then
               return new CdcTablePolicyFieldDataSource().*/
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
         hbuffer = phDataset:get-buffer-handle ("ttCdcTablePolicy").
         if valid-handle(hbuffer) then
         do:
             datasource = GetSaveSource("ttCdcTablePolicy").
             datasource:Refresh(hBuffer).
         end.  
    end method.
    
    method public override void FetchData(msg as IFetchRequest): 
        Url = msg:url.
        DatasetHandle = msg:DataHandle.       
        FillData(msg).
    end method.    
    
    method public void FillNewFieldPolicies(hBuffer as handle,pcQuery as char ):
        define variable fieldPolicySource as IDataSource no-undo.
        fieldPolicySource = new CdcFieldPolicyDataSource().
        fieldPolicySource:FillMode = "Append".
        fieldPolicySource:Prepare(hBuffer,pcQuery,"").
        fieldPolicySource:Fill().    
    end.
    
        method public void FillData(msg as IFetchRequest):
        define variable hCdcTablePolicyBuffer as handle no-undo.
        define variable fieldPolicySource as IDataSource no-undo.
        define variable CdcTablePolicySource as IDataSource no-undo.        
        define variable tableRequest as ITableRequest no-undo.     
        define variable hFieldPolicy  as handle no-undo.        
        define variable hPartition as handle no-undo.
        //define variable hindex as handle no-undo.
        define variable lChildBatch  as logical no-undo.
        define variable i as integer no-undo.
        define variable hBuff as handle no-undo.
        
        hFieldPolicy = msg:DataHandle:get-buffer-handle ("ttCdcFieldPolicy").

        if valid-handle(hFieldPolicy) then
        do:
             if msg:GetTableRequestType("ttCdcFieldPolicy") = "NEW" then
             do:
                 tableRequest = msg:GetTableRequest("ttCdcFieldPolicy").
                 FillNewFieldPolicies(hFieldPolicy,tableRequest:QueryString).
                 return.   
             end. 
    
             hCdcTablePolicyBuffer = msg:DataHandle:get-buffer-handle ("ttCdcTablePolicy").
              
             if valid-handle(hFieldPolicy:parent-relation) or not valid-handle(hCdcTablePolicyBuffer) then
             do:
                 
                 fieldPolicySource = new CdcFieldPolicyDataSource().
                 fieldPolicySource:FillMode = "Replace".
                 fieldPolicySource:Url = URL.
                 
                 tableRequest = msg:GetTableRequest("ttCdcFieldPolicy").
                 
                 if valid-handle(hFieldPolicy:parent-relation) and tableRequest:Start > 0 then
                 do:
                     lChildBatch = true.
                     hFieldPolicy:fill-mode = "No-fill".
                 end.
                 else do:                    
                     if valid-object(tableRequest) then 
                         fieldPolicySource:Prepare(hFieldPolicy,tableRequest).         
                     else
                         fieldPolicySource:Prepare(hFieldPolicy).            
                 end.
             end.
             else do:
                 /* used to map in detail, so start first */
                 CdcTablePolicySource = new CdcTablePolicyDataSource().   
                 CdcTablePolicySource:FillMode = "Replace".
                 CdcTablePolicySource:Url = URL.
                 /* PartitionPolicy critera is added to parent detail */
                 CdcTablePolicySource:Prepare(hCdcTablePolicyBuffer).      
                 fieldPolicySource = new CdcFieldPolicyDataSource().
                 fieldPolicySource:FillMode = "Append".
                 fieldPolicySource:Url = URL.
                 
                 /* get PartitionPolicy critera (join with detail) and add to parent detail */
                 tableRequest = msg:GetTableRequest("ttCdcTablePolicy").
                 
                 if valid-object(tableRequest) then 
                     fieldPolicySource:Prepare(hFieldPolicy,tableRequest).         
                 else
                     fieldPolicySource:Prepare(hFieldPolicy).            
             
                 
             end.      
        end.
        /*
        hFieldPolicy = msg:DataHandle:get-buffer-handle ("ttCdcFieldPolicy").
        if valid-handle(hFieldPolicy) then
        do:
  
            fieldPolicySource = new CdcFieldPolicyDataSource().   
            fieldPolicySource:FillMode = "Append".
            fieldPolicySource:Url = URL.
            tableRequest = msg:GetTableRequest("ttCdcFieldPolicy").
  
            if valid-object(tableRequest) then 
                fieldPolicySource:Prepare(hFieldPolicy,tableRequest).         
            else
                fieldPolicySource:Prepare(hFieldPolicy).            
        end.*/
        
        if not valid-object(CdcTablePolicySource) then
        do:
            hCdcTablePolicyBuffer = msg:DataHandle:get-buffer-handle ("ttCdcTablePolicy").
                
            if valid-handle(hCdcTablePolicyBuffer) then
            do:
      
                CdcTablePolicySource = new CdcTablePolicyDataSource().   
                CdcTablePolicySource:FillMode = "Replace".
                CdcTablePolicySource:Url = URL.
            
                tableRequest = msg:GetTableRequest("ttCdcTablePolicy").
      
                if valid-object(tableRequest) then 
                    CdcTablePolicySource:Prepare(hCdcTablePolicyBuffer,tableRequest).         
                else
                    CdcTablePolicySource:Prepare(hCdcTablePolicyBuffer).            
            end.             
        end.
        

        /*
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
  
            PartitionPolicyFieldSource = new PartitionPolicyFieldDataSource().   
            PartitionPolicyFieldSource:FillMode = "Append".
            PartitionPolicyFieldSource:Url = URL.
            tableRequest = msg:GetTableRequest("ttPartitionPolicyField").
  
            if valid-object(tableRequest) then 
                PartitionPolicyFieldSource:Prepare(hPolicyField,tableRequest).         
            else
                PartitionPolicyFieldSource:Prepare(hPolicyField).            
        end.   */                                
        
        hPartition = msg:DataHandle:get-buffer-handle ("ttPartition").
        if valid-handle(hPartition) then
        do:
            hPartition:fill-mode = "no-fill".
        end.
        
         if valid-object(CdcTablePolicySource) then
        do:
            if CdcTablePolicySource:NumRecords <> ? then 
                msg:SetTableTotal("ttCdcTablePolicy",CdcTablePolicySource:NumRecords).        
        end.
        else if valid-object(fieldPolicySource) then
        do:
            if fieldPolicySource:NumRecords <> ? then 
                msg:SetTableTotal("ttCdcFieldPolicy",fieldPolicySource:NumRecords).        
        end.
    
        DatasetHandle:Fill().
    
        if lChildBatch then
        do: 
            do i = 1 to msg:DataHandle:num-buffers:
                hBuff = msg:DataHandle:get-buffer-handle (i).    
                if hBuff:name = "ttCdcFieldPolicy" then
                do:
                    tableRequest = msg:GetTableRequest("ttCdcFieldPolicy").
                    fieldPolicySource:Prepare(hFieldPolicy,tableRequest). 
                    fieldPolicySource:FillMode = "Append".   
                end.
                else 
                   hBuff:fill-mode = "no-fill".
            end.
            DatasetHandle:Fill().
        end.
           
        if valid-handle(hPartition) then
            //fillPartitions(msg).
             
       
        /* no GC - must delete - due to dataset event callback*/
        finally: 
            delete object fieldPolicySource no-error.   
            //delete object localIndexSource no-error.   
            delete object CdcTablePolicySource no-error.    
            //delete object PartitionPolicyFieldSource no-error.          
        end finally. 
    end method.
    
        method private void fillPartitions(msg as IFetchRequest) :
        define variable i as integer no-undo. 
        define variable hParent    as handle no-undo.
        define variable hPartition as handle no-undo.
        define variable hBuffer    as handle no-undo. 
        define variable cjoin as character no-undo.
       
        define variable partitionSource as IDataSource no-undo.
        //define variable indexPartitionSource as IDataSource no-undo.
        //define variable fieldPartitionSource as IDataSource no-undo.
        define variable tableRequest as ITableRequest no-undo.     
        define variable cQuery as character no-undo.
       message "fill partition" view-as alert-box.
        do i = 1 to DatasetHandle:num-buffers:
            hbuffer = DatasetHandle:get-buffer-handle(i).
            if hbuffer:name <> "ttPartition" then
            do:
                hbuffer:fill-mode = "no-fill".
                if hBuffer:name = "ttCdcFieldPolicy" then
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
              /*+ " and _StorageObject._object-number = ttCdcFieldPolicy.ObjectNumber "
              + " and _StorageObject._PartitionId   = ttPartitionPolicyDetail.Id "*/.

        partitionSource = new PartitionDataSource(hParent,
                                            "for each ttCdcFieldPolicy,"
                                            + " each _storageObject " + cjoin + " no-lock").
        partitionSource:FillMode = "Append".
       
        partitionSource:Url = Url.
       
        if valid-object(tableRequest) then 
            partitionSource:Prepare(hPartition,tableRequest).         
        else
            partitionSource:Prepare(hPartition).            
       
        partitionSource:Prepare(hPartition,cQuery,"").
        DatasetHandle:Fill().
/*
        indexPartitionSource = new IndexPartitionDataSource(hParent,
                                     /*"_file._File-number = ttPartitionPolicyDetail.ObjectNumber"*/ "",
                                     /*"_StorageObject._PartitionId = ttPartitionPolicyDetail.Id"*/"").
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
       
        DatasetHandle:Fill().*/
        hPartition:fill-mode = "no-fill".
        /* no GC - must delete due to dataset event callback*/
        finally: 
            delete object partitionSource no-error.     
           // delete object indexPartitionSource no-error.     
            //delete object fieldPartitionSource no-error.            
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
                         + replace(e:GetMessage(i),"_Cdc-Field-policy","CdcFieldPolicy")  + "."  . 
                    lTrans = true.      
                end.                   
                when 17576 then
                do:
                     cMsg = (if i = 1 then "" else cMsg + lf)
                          + replace(e:GetMessage(i),"_Cdc-Field-policies","CdcFieldPolicies")  + "."  . 
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