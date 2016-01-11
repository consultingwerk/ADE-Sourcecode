/*************************************************************/
/* Copyright (c) 2011,2013 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
/*------------------------------------------------------------------------
    Purpose     : abstract query for partitions of a schema element 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Apr 2011
    Notes       : Known subclasses TablePartitionQuery, IndexPartitionQuery 
                  and FieldPartitionQuery 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IPartitionContext.
using OpenEdge.DataAdmin.Binding.IRow from propath.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.Query.IPartitionQuery.
using OpenEdge.DataAdmin.Binding.Query.PartitionQuery.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using Progress.Lang.*.

routine-level on error undo, throw.
class OpenEdge.DataAdmin.Binding.Query.SchemaPartitionQuery abstract inherits PartitionQuery  : 
	/*------------------------------------------------------------------------------
			Purpose: Used for a collection of partitions of a schema element
			 		 mapped by tenant or group															  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	/** Parent context (Model) may change so don't store this */
	define private property PartitionContext as PartitionContext no-undo
	    get():
	        return cast(Model,PartitionContext).   
	    end.
	    
    define protected variable TableName as character no-undo.
	define protected variable FieldName as character no-undo.
    define protected variable IndexName as character no-undo.
    define protected variable Collation as character no-undo.
    
	constructor protected SchemaPartitionQuery (pdatacontext as PartitionContext, pRow as IRow,preq as IRequestInfo):
        super (pdatacontext,pRow,pReq).
        
        /* use FieldValue to allow current number and order of extents in key to change 
          - SchemaName may or may not be in key      
          (can alternatively use KeyFields to find correct entry) */
      
        case pRow:SerializeName:
            when "table" then
                TableName = pRow:FieldValue("Name").     
            when "fields" then
                assign
                    TableName = pRow:FieldValue("TableName")     
                    FieldName = pRow:FieldValue("Name").     
            when "indexes" then 
                assign
                    TableName = pRow:FieldValue("TableName")   
                    IndexName = pRow:FieldValue("Name")
                    /* future                    
                    Collation = pRow:FieldValue("CollationName")*/
                    .
        end case.      
    end constructor.
    
    method public override logical CanFind(pname as character):
        undo, throw new UnsupportedOperationError("SchemaPartitionQuery CanFind with single key").
    end.    
     
    method public override logical Find(pname as character):
        undo, throw new UnsupportedOperationError("SchemaPartitionQuery Find with single key").
    end.
      
    method public override logical FindTable(pname as character):
        undo, throw new UnsupportedOperationError("SchemaPartitionQuery FindTable").
    end.   
     
    method public override logical FindIndex(pname as character,pcIndex as char,pccol as char):
        undo, throw new UnsupportedOperationError("SchemaPartitionQuery FindIndex").
    end.    
        
    method public override logical FindField(pname as character,pcField as char):
        undo, throw new UnsupportedOperationError("SchemaPartitionQuery FindField").
    end.    
        
/*    method public override IFetchRequest GetQueryRequest():*/
/*        define variable tree   as IContextTree no-undo.    */
/*        define variable hds    as handle no-undo.          */
/*                                                           */
/*        tree = new ContextTree().                          */
/*        AddTableTo(tree).                                  */
/*        hds = tree:GetReadHandle().                        */
/*        return new FetchRequest(Name,Id,hds).              */
/*                                                           */
/*    end method.                                            */
/*                                                           */
    method public override void ExportLastSaved(pcfile as char). 
        define variable hBuffer as handle no-undo.
        if valid-handle(LastSavedDataset) then
        do:
            hbuffer = LastSavedDataset:get-buffer-handle(TableHandle:Name) . 
            /*
            hbuffer:buffer-field ("SchemaName"):serialize-hidden = true.
            hbuffer:buffer-field ("SequenceName"):serialize-hidden = true.
            hbuffer:buffer-field ("Url"):serialize-hidden = true.         
             */
            if valid-handle(hBuffer) then 
                hBuffer:write-json ("File",pcFile,yes).    
        end.
    end method.  
    
    method public logical CanFindTenant(pcTenant as char):      
        if PartitionContext:FindTenant(pcTenant,TableName,FieldName,Indexname,Collation) then
            return CanFindCurrentModel(PartitionContext).
        return false.   
    end method.
    
    method public logical CanFindGroup(pcGroup as char):      
        if PartitionContext:FindGroup(pcGroup,TableName,FieldName,Indexname,Collation) then
            return CanFindCurrentModel(PartitionContext).
        return false.   
    end method.
    
    method public logical CanFindPolicyDetail(pcDetail as char):
        if PartitionContext:FindPolicyDetail(pcDetail,TableName,FieldName,Indexname,Collation) then
            return CanFindCurrentModel(PartitionContext).
        return false.   
    end method.
     
    method public logical FindTenant(pcTenant as char):
        if PartitionContext:FindTenant(pcTenant,TableName,FieldName,Indexname,Collation) then
            return SynchWithModel(PartitionContext).
        return false.   
    end method.
    
    method public logical FindGroup(pcGroup as char):
        if PartitionContext:FindGroup(pcGroup,TableName,FieldName,Indexname,Collation) then
            return SynchWithModel(PartitionContext).
        return false.   
    end method.
    
    method public logical FindPolicyDetail(pcDetail as char):
        if PartitionContext:FindPolicyDetail(pcDetail,TableName,FieldName,Indexname,Collation) then
            return SynchWithModel(PartitionContext).
        return false.   
    end method.   
    
    method public override logical CanFindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):      
        if pcTable = TableName and pcField = FieldName and pcIndex = Indexname and pcCollation = Collation then  
            return CanFindTenant(pcTenant).
        else
            return false.
    end method.
    
    method public override logical CanFindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):
        if pcTable = TableName and pcField = FieldName and pcIndex = Indexname and pcCollation = Collation then  
            return CanFindGroup(pcGroup).
        else
            return false.
    end method.
      
    method public override logical CanFindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):
        if pcTable = TableName and pcField = FieldName and pcIndex = Indexname and pcCollation = Collation then  
            return CanFindPolicyDetail(pcDetail).
        else
            return false.
    end method.
    
    method public override logical FindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):
        if pcTable = TableName and pcField = FieldName and pcIndex = Indexname and pcCollation = Collation then  
            return FindTenant(pcTenant).
        else
            return false.
    end method.
    
    method public override logical FindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):
        if pcTable = TableName and pcField = FieldName and pcIndex = Indexname and pcCollation = Collation then  
            return FindGroup(pcGroup).
        else
            return false.
    end method.
    
    method public override logical FindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):
        if pcTable = TableName and pcField = FieldName and pcIndex = Indexname and pcCollation = Collation then  
            return FindPolicyDetail(pcDetail).
        else
            return false.
    end method.   
    
    method public IDataAdminElement FindGroupEntity(pcGroup as char):
        define variable hBuffer as handle no-undo.
        if FindGroup(pcGroup) then
        do:
            hBuffer = QueryHandle:get-buffer-handle (this-object:Table).
            return Model:FindEntity(hBuffer,RequestInfo).  
        end.          
    end method.  
    
    method public IDataAdminElement FindTenantEntity(pcTenant as char):
        define variable hBuffer as handle no-undo.
        if FindTenant(pcTenant) then
        do:
            hBuffer = QueryHandle:get-buffer-handle (this-object:Table).
            return Model:FindEntity(hBuffer,RequestInfo).  
        end.                   
    end method.  
    
    method public IDataAdminElement FindPolicyDetailEntity(pcDetail as char):
        define variable hBuffer as handle no-undo.
        if FindPolicyDetail(pcDetail) then
        do:
            hBuffer = QueryHandle:get-buffer-handle (this-object:Table).
            return Model:FindEntity(hBuffer,RequestInfo).  
        end.                                    
    end method. 
    
    
    /****
    method public logical Deallocate(): 
        undo, throw new UnsupportedOperationError("Allocate() in SchemaPartitionContext. Use TablePartitionContext").    
    end method.     
    ****/
    method public override logical Allocate():        
        return AllocateTenants("Delayed"). 
    end method.     
    
    /** Allocate group partitions for the parent schema elelement    
        @param AllocationState Specify state of partitions to allocate - All, Delayed or None 
        @return true if any partition was allocated 
        @throw IllegalArgumentError if not valid AllocationState */     
    method public logical AllocateGroups(pcAllocationState as char):        
        define variable rid as rowid no-undo. 
        define variable lTrack as logical no-undo.
        define variable lok as logical no-undo.
        define variable hBuf as handle no-undo.
        PartitionContext:ValidateAllocationRequest(pcAllocationState).
        lTrack = TableHandle:tracking-changes.
        TableHandle:tracking-changes = true. 
        hBuf = QueryHandle:get-buffer-handle(this-object:Table).
        
        rid = hBuf:rowid.
        QueryHandle:get-first ().
        do while hBuf:avail: 
            if hBuf::tenantgroupName > "" 
            and (hBuf::AllocationState = pcAllocationState
                 or (hBuf::AllocationState <> "Allocated" 
                     and 
                     pcAllocationState = "All")) then
            do:
                lok = true.
                hBuf::AllocationState = "Allocated".
            end. 
            QueryHandle:get-next ().
        end.
        return lok.
        finally:
            TableHandle:tracking-changes = lTrack.          
            if rid <> ? then
                QueryHandle:reposition-to-rowid(rid). 
        end finally.       
    end method.     

   /** Allocate tenant partitions for the parent schema elelement    
        @param AllocationState Specify state of partitions to allocate - All, Delayed or None 
        @return true if any partition was allocated 
        @throw IllegalArgumentError if not valid AllocationState */     
    method public logical AllocateTenants(pcAllocationState as char):        
        define variable rid as rowid no-undo. 
        define variable lTrack as logical no-undo.
        define variable lok as logical no-undo.
        define variable hBuf as handle no-undo.
       
        PartitionContext:ValidateAllocationRequest(pcAllocationState).
        
        lTrack = TableHandle:tracking-changes.
         
        TableHandle:tracking-changes = true. 
        hBuf = QueryHandle:get-buffer-handle (this-object:Table).
        rid = hBuf:rowid.
        QueryHandle:get-first ().
        
        do while hBuf:avail: 
            if hBuf::TenantName > "" 
            and (hBuf::AllocationState = pcAllocationState
                 or (hBuf::AllocationState <> "Allocated" 
                     and 
                     pcAllocationState = "All")) then
            do:
                lok = true.
                hBuf::AllocationState = "Allocated".
            end. 
            QueryHandle:get-next ().
       
        end.
      
        return lok.
        finally:
            TableHandle:tracking-changes = lTrack.          
            if rid <> ? then
                QueryHandle:reposition-to-rowid(rid). 
        end finally.       
    end method.     
         
    /*    
    method public override character ColumnSource(pcColumn as char):
        define variable cField  as character no-undo.
        define variable cBuffer as character no-undo.
        
        define variable cMsg as character no-undo. 
        /*
        if num-entries(pcColumn,".") > 1 then
        do:
            cBuffer = entry(1,pcColumn,".").
            cField  = entry(2,pcColumn,".").
            if cBuffer = "tenant" then
            do:
                return Tenantcontext:ColumnSource(cField).
            end.    
        end.
        */
        return super:ColumnSource(pcColumn).
    end method.
    */
    
    
end class.