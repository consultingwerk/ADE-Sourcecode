/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
   File        : PartitionData 
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : hdaniels
   Created     :  
   Notes       : The partitions are indexed from object and not from 
                 tenant or area so we always access through the objects.
              -  If the filter has a unique tenant and/or area expression  
                 these key values are added to the storageobject in the fill query.
              -  If the filter has a non-unique tenant and/or area expression  
                 the buffers with queries are added to the fill query.                  
 ----------------------------------------------------------------------*/
 
routine-level on error undo, throw.

using Progress.Lang.Error from propath.
using Progress.Lang.SysError from propath.
using OpenEdge.DataAdmin.Error.DataError from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccess from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.DataAccess.IDataAccess from propath.
using OpenEdge.DataAdmin.DataSource.PartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.TablePartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.IndexPartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.FieldPartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.NewTablePartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.NewIndexPartitionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.NewFieldPartitionDataSource from propath.
using OpenEdge.DataAdmin.Message.ISaveRequest from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Lang.IQueryMap from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath.

class OpenEdge.DataAdmin.DataAccess.PartitionData inherits DataAccess implements IDataAccess, IQueryMap: 
    
/*    define buffer b_Area      for dictdb._Area.  */
/*    define buffer b_Tenant    for dictdb._Tenant.*/
/*    define buffer b_LobArea   for dictdb._Area.  */
/*    define buffer b_dataArea  for dictdb._Area.  */
/*    define buffer b_indexArea for dictdb._Area.  */

   define temp-table ttobjecttype no-undo
        field name as char
     /*   field typeno as int  1 2 or 3 .. */
        index idxtype as unique name.
        
    
   define private variable mUrl as character no-undo.    
   
    /*
   define protected property StateEnum as PartitionStateEnum no-undo
       get():
           if not valid-object(StateEnum) then        
              StateEnum = new PartitionStateEnum().
           return StateEnum.
       end.
       private set.
*/
    /*    define query dsextent for dictdb._areaextent,b_Area.*/
    /*    define data-source dsExtent for query dsextent.     */
    define private variable TenantURL as character no-undo.
    define private variable AreaURL   as character no-undo.
    
    define public property BaseQuery as character no-undo
        get.
        set.
    
    method public override ISaveRequest SaveData(pChanges as ISaveRequest): 
         define variable hDs as handle no-undo.
         define variable hBuffer as handle no-undo.
         define variable partitionSource as PartitionDataSource no-undo.
         partitionSource = GetSource(). 
         hds = pChanges:DataHandle.
         do transaction on error undo, throw:
             hBuffer = hDs:get-buffer-handle("ttPartition").
             partitionSource:Save(hBuffer).
         end.
         return pChanges.     
    end method.   
    
    method private PartitionDataSource GetSource():
        define variable partitionSource as PartitionDataSource no-undo.
        partitionSource = new  PartitionDataSource( ).
        partitionSource:Url = mUrl.
        return partitionsource.
    end.
    
    method private TablePartitionDataSource GetTableSource():
        define variable partitionSource as TablePartitionDataSource no-undo.
        partitionSource = new  TablePartitionDataSource().
        partitionSource:Url = mUrl.
        return partitionsource.
    end.
    
    method private PartitionDataSource GetNewTableSource():
        define variable partitionSource as PartitionDataSource no-undo.
        partitionSource = new  NewTablePartitionDataSource().
        partitionSource:Url = mUrl.
        return partitionsource.
    end.
       
    method private IndexPartitionDataSource GetIndexSource():
        define variable partitionSource as IndexPartitionDataSource no-undo.
        partitionSource = new  IndexPartitionDataSource().
        partitionSource:Url = mUrl.
        return partitionsource.
    end.
    
    method private PartitionDataSource GetNewIndexSource():
        define variable partitionSource as PartitionDataSource no-undo.
        partitionSource = new  NewIndexPartitionDataSource().
        partitionSource:Url = mUrl.
        return partitionsource.
    end.
    
    method private FieldPartitionDataSource GetFieldSource():
        define variable partitionSource as FieldPartitionDataSource no-undo.
        partitionSource = new  FieldPartitionDataSource().
        partitionSource:Url = mUrl.
        return partitionsource.
    end.
    
    method private PartitionDataSource GetNewFieldSource():
        define variable partitionSource as PartitionDataSource no-undo.
        partitionSource = new  NewFieldPartitionDataSource().
        partitionSource:Url = mUrl.
        return partitionsource.
    end.
    
     
    method protected override void SetUrl(pcUrl as char):
        if pcUrl > "" then
            mUrl = pcUrl.
        TenantUrl =  pcurl + "/tenants/".
        AreaURL = pcurl + "/areas/".
    end method.
    
    method public override void FetchData(msg as IFetchRequest):
        SetUrl(msg:Url).
        DatasetHandle = msg:DataHandle. 
        FillData(msg).
    end method.
    
    method protected void FillData(pMsg as IFetchRequest):
        define variable hBuffer as handle  no-undo. 
        define variable lok     as logical no-undo .
        define variable lindexsearch     as logical no-undo .
        define variable lfieldsearch as logical no-undo .
        define variable hParent as handle no-undo.
        define variable lfileonly as logical no-undo .
        define variable queryStr     as QueryString no-undo.
        define variable cObjectType  as character no-undo .
        define variable partitionSource as PartitionDataSource no-undo.
        define variable cjoin as character no-undo.
        define variable filter as character no-undo.
        define variable lSimulation as logical no-undo.
        filter = pMsg:GetTableQuery("ttPartition").
        
        hBuffer = DatasetHandle:get-buffer-handle("ttPartitionIdRequest").
        if valid-handle(hBuffer) then
        do:
            partitionSource = new  PartitionDataSource(hbuffer,
                                   "for each ttPartitionIdRequest, "
                                   + " each _StorageObject where _StorageObject._PartitionId = ttPartitionIdRequest.PartitionId no-lock" ).
            partitionSource:Url = mUrl.
            hBuffer:fill-mode = "no-fill".
            hBuffer = DatasetHandle:get-buffer-handle("ttPartition").
            partitionSource:FillMode = "Append".
            partitionSource:Prepare(hBuffer,filter,""). 
            DatasetHandle:Fill().     
            /* is not garbage collected if set-callback is used */
            delete object partitionSource.
       
            RETURN.   
        end.
               
        hBuffer = DatasetHandle:get-buffer-handle("ttTablePartitionRequest").
        if valid-handle(hBuffer) then
        do:
            hBuffer:fill-mode = "no-fill".
            hParent = hbuffer.
            hBuffer = DatasetHandle:get-buffer-handle("ttPartition"). 
            cJoin = "_file._file-name = ttTablePartitionRequest.TableName".
            
            partitionSource = new TablePartitionDataSource(hParent,cjoin).
            partitionSource:FillMode = "Append".
            partitionSource:Url = mUrl.
            partitionSource:Prepare(hBuffer,"","").
            DatasetHandle:Fill().
            /* is not garbage collected if set-callback is used */
            delete object partitionSource.
        
            partitionSource = new IndexPartitionDataSource(hParent,cjoin). 
            partitionSource:FillMode = "Append".
            partitionSource:Url = mUrl.
            partitionSource:Prepare(hBuffer,"","").
            DatasetHandle:Fill().
             /* is not garbage collected if set-callback is used */
            delete object partitionSource.
            
            partitionSource = new FieldPartitionDataSource(hParent,cjoin).
            partitionSource:FillMode = "Append".
            partitionSource:Url = mUrl.
            partitionSource:Prepare(hBuffer,"","").
            DatasetHandle:Fill().
             /* is not garbage collected if set-callback is used */
            delete object partitionSource.
       
            /* @TODO seems wrong ?? */     
            hbuffer:fill-mode = "no-fill".          
            RETURN.   
        
        end.
        
        hBuffer = DatasetHandle:get-buffer-handle("ttGroupNameRequest").
        if valid-handle(hBuffer) then
        do:
            hBuffer:fill-mode = "no-fill".
            hParent = hbuffer.
            hBuffer = DatasetHandle:get-buffer-handle("ttPartition"). 
            cJoin = "where _StorageObject._object-type = ttGroupNameRequest.objectType "        
                 + " and _StorageObject._object-number = ttGroupNameRequest.ObjectNumber "
                 + " and _StorageObject._PartitionId = ttGroupNameRequest.Id ".
            partitionSource = new PartitionDataSource(hParent,
                                                "for each ttGroupNameRequest, each _storageObject " + cjoin + " no-lock").
            partitionSource:FillMode = "Append".
            partitionSource:Url = mUrl.
            partitionSource:Prepare(hBuffer,"","").
            DatasetHandle:Fill().
            /* is not garbage collected if set-callback is used */
            delete object partitionSource.
   
            partitionSource = new IndexPartitionDataSource(hParent,
                         "_file._File-number = ttGroupNameRequest.ObjectNumber",
                         "_StorageObject._PartitionId = ttGroupNameRequest.Id"  ).
            partitionSource:FillMode = "Append".
            partitionSource:Url = mUrl.
            partitionSource:Prepare(hBuffer,"","").
            DatasetHandle:Fill().
            /* is not garbage collected if set-callback is used */
            delete object partitionSource.
   
            partitionSource = new FieldPartitionDataSource(hParent,
                         "_file._File-number = ttGroupNameRequest.ObjectNumber",
                         "_StorageObject._PartitionId = ttGroupNameRequest.Id"  ).
            partitionSource:FillMode = "Append".
            partitionSource:Url = mUrl.
            partitionSource:Prepare(hBuffer,"","").
            DatasetHandle:Fill().
             /* is not garbage collected if set-callback is used */
            delete object partitionSource.
            
            
            hbuffer:fill-mode = "no-fill".          
            RETURN.   
        end.
        else do:
            /* RequestTyp NEW is special case for new tenant or group */
            lSimulation = pmsg:GetTableRequestType("ttPartition") = "NEW". 
            hBuffer = DatasetHandle:get-buffer-handle("ttPartition").
            hBuffer:fill-mode = "merge".
             
             /*   check for index and field  
             Note that ObjectType = "Table" is for table only 
             while TableName is applied to both indexes, tables and fields 
            */ 
            
            if filter > "" then
            do:
                queryStr = new QueryString(filter,this-object).
                cObjectType = CheckQueryObjectType(queryStr). 
    
                case cObjectType: 
                    when ? then
                       undo, throw new IllegalArgumentError("Ambiguous or invalid ObjectType expression in partition request:" + quoter(filter) + ".").
                    when "Table" then
                        assign
                            lfileonly = true.
                    when "Index" then 
                        lindexsearch = true.
                    when "Field" then 
                        lfieldsearch = true.
                    when "" then
                    do:                                                                                          
                        lindexsearch = CheckQuery(queryStr,"_index").
                        lfieldsearch = CheckQuery(queryStr,"_field").
 
                    end.
                end.
            end.
            
            /* these can be true also if there is an OR with other tables */
            if lindexsearch or lfieldsearch then
            do:
               /* this is somewhat restrictive, but it difficult to 
                  decide what a "tablename begins 'a' or fieldname begins 'a'" 
                  requestwould mean since the file and index are children 
                  of table... Partitions are either for index, lob or table
                   */
               if lindexsearch and lfieldsearch then
                   undo, throw new UnsupportedOperationError("PartitionData filter request on both indexes and fields."). 
               
               if lindexsearch then
               do:
                   lok = FillIndexPartitions(hbuffer,filter,lsimulation).
               end.
               if lfieldsearch then
               do: 
                   lok = FillFieldPartitions(hbuffer,filter,lsimulation).
               end.
            end.
            else do:
/*              define variable i as integer no-undo.*/
/*              define variable i2 as integer no-undo.*/
/*              define variable i3 as integer no-undo.*/
/*              define variable i4 as integer no-undo.*/
/*                                                    */
/*                 i = etime.                         */
                
                lok = FillTablePartitions(hbuffer,filter,lsimulation).
/*                i4 = etime - i.*/
                if lok and not lfileonly then
                do:
/*                    i2 = etime.*/
                    FillIndexPartitions(hbuffer,filter,lsimulation).
/*                    i2 = etime - i2.*/
/*                    i3 = etime.     */
                    FillFieldPartitions(hbuffer,filter,lsimulation).
/*                    i3 = etime - i3.*/
/*                i = etime - i.      */
                end.
/*                message                       */
/*                   "tables" i4 skip           */
/*                   "indexes" i2 skip          */
/*                   "fields" i3  skip          */
/*                   "total fill" i i4 + i2 + i3*/
/*                view-as alert-box.            */
            end.
        end.
    end method.

    /* This is the call back for the QueryString parsing. There is currently no mapping, but we override it in 
       order to return the ttPartition's parent keys to the Query. This allows us to extract the expression later.
       Because it is added as parent (i.e _tenant) we can also extract the actual query fields without these.        
    */
    method public override character ColumnSource (pcColumn as char):
        if pcColumn = "ttPartition.ObjectType" then 
        do:
            /* table index or field */
            return "ttobjecttype.name".    
        end.
        return pccolumn.     
   
    end method.     

   
    /* returns blank if no type reference in query 
               ? if not unique (ambiguous or not found)
                Table, Index or Field   */
    method private character CheckQueryObjectType(pQueryStr as QueryString):
        define variable cParentQuery as char no-undo.       
        define variable cType        as char no-undo.    
        define variable ipos         as integer no-undo.   
        cParentQuery = pQueryStr:BuildParsedQueryString("ttobjecttype").
        ipos = index(cParentQuery," where ").
        if ipos > 0 then
        do:
            cType = FindObjectType(substr(cParentQuery,ipos + 1)).
            if ctype = ? then
                return ?.
            return ctype.
        end.
        return "".

    end method.

    method private logical CheckQuery(pQueryStr as QueryString,pcTable as char):
        define variable cParentQuery as char no-undo.     
        cParentQuery = pQueryStr:BuildParsedQueryString(pcTable).
        return index(cParentQuery," where ") <> 0.
    end.
    
    method private character FindObjectType(pFind as char):
        define variable lok as logical no-undo. 
        if not can-find(first ttObjectType) then
        do:
            create ttobjecttype.
            ttobjecttype.name = "Table".
            create ttobjecttype.
            ttobjecttype.name = "Index".       
            create ttobjecttype.
            ttobjecttype.name = "Field".
        end.       
        if buffer ttobjecttype:find-unique(pFind) then
           return ttobjecttype.name.
        return ?.   
    end method.

    method private logical FillTablePartitions(phBuffer as handle,filter as char,plsim as log): 
        define variable lok as logical no-undo.
        define variable src as PartitionDataSource no-undo.
        if not plsim then 
            src = GetTableSource().  
        else
            src = GetNewTableSource().  
        
        src:FillMode = "Append".
        lok = src:Prepare(phBuffer,filter,"").
         
        if lok then 
        do on error undo, throw:       
            DatasetHandle:Fill() .
            catch e as Progress.Lang.Error :
            	undo, throw new DataAccessError(e).	
            end catch.
            /*
            if error-status:error then
            do:
                define variable i as integer no-undo.
                do i = 1 to error-status:num-messages:
                    message error-status:get-message (i)
                    view-as alert-box.
                end.
            end.
            */
        end.
        return lok.        
        finally:  /* is not garbage collected if set-callback is used */
            delete object src no-error. 
        end finally.                
                  
    end method.
      
    method private logical FillIndexPartitions(phBuffer as handle,filter as char,plsim as log): 
        define variable lok as logical no-undo.
        define variable src as PartitionDataSource no-undo.
        if not plSim then 
            src = GetIndexSource().  
        else 
            src = GetNewIndexSource().  
        src:FillMode = "Append".
        lok = src:Prepare(phBuffer,filter,"").
        if lok then        
            DatasetHandle:Fill().
            
        return lok.
        finally:  /* is not garbage collected if set-callback is used */
            delete object src no-error.	
        end finally.                
    end method.
    
    method private logical FillFieldPartitions(phBuffer as handle,filter as char,plsim as log): 
        define variable lok as logical no-undo.
        define variable src as PartitionDataSource no-undo.
        if not plsim then
            src = GetFieldSource().
        else 
            src = GetNewFieldSource().
              
        src:FillMode = "Append".
        lok = src:Prepare(phBuffer,filter,"").
        if lok then 
            DatasetHandle:Fill(). 
        
        return lok.    
        finally:  /* is not garbage collected if set-callback is used */
            delete object src no-error.  
        end finally.               
    end method.
 
end class.
