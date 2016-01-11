/*************************************************************/
/* Copyright (c) 2011-2013 by Progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    File        : SequenceValueContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :   2011
    Notes       :                                                              
            
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextFactory.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.Query.SequenceTenantQuery.
using OpenEdge.DataAdmin.Binding.Query.TenantSequenceQuery.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.IFetchResponse.
using OpenEdge.DataAdmin.SequenceValue.
using OpenEdge.DataAdmin.Support.SequenceSequenceValueMap.
using OpenEdge.DataAdmin.Support.TenantSequenceValueMap.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.


class OpenEdge.DataAdmin.Binding.SequenceValueContext inherits DataAdminContext  : 
    
    {daschema/sequencevalues.i}
     
    define private dataset dsSequenceValue serialize-name "root" for ttSequenceValue.
    define buffer bSequence for ttSequenceValue.
    define temp-table copySequenceValue reference-only like ttSequenceValue .  
    define private variable mRefresh as logical no-undo.
    define private variable ContextFactory as IContextFactory no-undo.
    
    define public property SchemaName as character  no-undo  
        get. 
        private set.   
    
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttSequenceValue:handle.
    	end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return TableHandle:default-buffer-handle:keys. 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bSequenceValue for ttSequenceValue.
            if Count = ? then
            do:
                Count = 0.
                for each bSequenceValue:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
    
    constructor public SequenceValueContext ():
        super ("SequenceValue").
    end constructor.
    
    constructor public SequenceValueContext ( pschema as char,pscope as IContextFactory):
        super ("SequenceValue",pscope).
        ContextFactory = pscope.
        SchemaName = pschema.     
    end constructor.
    
        /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsSequenceValue:handle. 
    end method.
    
	/* called with tracking-changes */
    method protected override void ReadRowForParent(prow as IRow,json as JSONObject).      
        case prow:SerializeName:
            when "tenants" then
            do:
                ReadTenantRow(prow:KeyValues[1],json).
            end.   
            when "sequences" then
            do:
                ReadSequenceRow(prow:KeyValues,json).
            end.
            otherwise 
                undo, throw new IllegalArgumentError("SequenceValueContext ReadRowForParent " + quoter(prow:SerializeName)).
        end.     
    end method.
    
    method private void ReadTenantRow(pcTenant as char,json as JSONObject):
        define variable h as handle no-undo.         
        
        define variable cSequence as character no-undo.
        define variable cSchema as character no-undo.
        
        h = buffer ttSequenceValue:buffer-field("SchemaName").
        cSchema =  json:GetCharacter(h:serialize-name).
        h = buffer ttSequenceValue:buffer-field("SequenceName").
        cSequence =  json:GetCharacter(h:serialize-name).
        
        find ttSequenceValue where ttSequenceValue.SchemaName = cSchema
                             and   ttSequenceValue.SequenceName = cSequence
                             and   ttSequenceValue.TenantName = pcTenant no-error.
        if not avail ttSequenceValue then  
            undo, throw new IllegalArgumentError(NotFoundError(cSchema,cSequence,pcTenant)).
        
        h = buffer ttSequenceValue:buffer-field("CurrentValue").
        ttSequenceValue.CurrentValue = json:GetInt64(h:serialize-name) .    
        
    end method. 
    
    method private void ReadSequenceRow(pcVal as char extent ,json as JSONObject):
        define variable h as handle no-undo.         
       
        define variable cTenant as character no-undo.
     
        h = buffer ttSequenceValue:buffer-field("TenantName").
        cTenant =  json:GetCharacter(h:serialize-name).
        
        find ttSequenceValue where ttSequenceValue.SchemaName = pcVal[1]
                             and   ttSequenceValue.SequenceName = pcVal[2]
                             and   ttSequenceValue.TenantName = cTenant no-error.
        if not avail ttSequenceValue then  
            undo, throw new IllegalArgumentError(NotFoundError(pcVal[1],pcVal[1],cTenant)).
        
        h = buffer ttSequenceValue:buffer-field("CurrentValue").
        ttSequenceValue.CurrentValue = json:GetInt64(h:serialize-name) .                 
    
    end method. 
    
    method private char NotFoundError(pcSchema as char,pcSeq as char,pcTnt as char):
        return  "SequenceValue" 
               + " SchemaName " + quoter(pcSchema)  
               + " SequenceName " + quoter(pcSeq)  
               + " TenantName " + quoter(pcTnt)  
               + " not found".
    end method.
    
     	
	method public override void CopyTable(cntxt as IDataAdminModel).
        undo, throw new UnsupportedOperationError("Copy SequenceValue").
    end method. 
     
    method public override void CreateRow(entity as IDataAdminElement):
        undo, throw new UnsupportedOperationError("Create SequenceValue").
    end method. 
	
    method public override character GetJoinFields(parentid as char):
        case parentid:
            when "tenants" then
                return "Name,TenantName".
            when "sequences" then
                return "SchemaName,SchemaName,Name,SequenceName".
        end.
    end.
    
    method public override character GetChildQuery(pParent as IRow).
        define variable cQuery as character no-undo.
       
        cQuery = super:GetChildQuery(pParent).
         
        case pParent:SerializeName:
            when "tenants" then
            do:
                cQuery = cQuery 
                       + ", "
                       +  GetJoinQuery("Sequence").
            end. 
            when "sequences" then
            do:
                cQuery = cQuery 
                       + ", "
                       +  GetJoinQuery("tenant").
            end.       
         end. 
         return cQuery.
    end method.
    
    method public override character  GetServerChildQuery(pParent as IRow).
        define variable cQuery as character no-undo.
        cQuery = super:GetServerChildQuery(pParent).
        case pParent:SerializeName:
            /* no join on server -  */
            when "tenants" then
            do:
                cQuery = cQuery + ", each ttSequence".
            end.    
             /* no join on server -  */
            when "sequences" then
            do:
                cQuery = cQuery + ", each ttTenant".
            end.    
            when "tenants" then
            do:
                cQuery = cQuery + ", each ttSequence".
            end.    
         end. 
         return cQuery.
    end method.  
      
     /**  Get default buffer handles 
          to use in child query for parent  
        - must match order of GetChildQuery
        @param serializename of parent   
       */
    method public override handle extent GetQueryHandles(parentid as char).  
        
        define variable h2 as handle extent 2 no-undo.
        
        case parentid:
               
            when "sequences" then
            do:
                h2[1] = TableHandle:default-buffer-handle.
                h2[2] = ContextFactory:TenantContext:TableHandle:default-buffer-handle.
                return h2.            
            end.
            when "tenants" then
            do:
                h2[1] = TableHandle:default-buffer-handle.
                h2[2] = ContextFactory:SequenceContext:TableHandle:default-buffer-handle.
                return h2.            
            end.
            otherwise do:
                return super:GetQueryHandles(parentid).
            end. 
        end.     
    end method.
    
    method override protected FilteredContext CreateFilteredContext(pParentRow as IRow,pReq as IRequestInfo):     
        case pParentRow:SerializeName:
            when "tenants" then
            do:
                return new TenantSequenceQuery (this-object,pParentRow,pReq).            
            end.                 
            when "sequences" then
            do:
                return new SequenceTenantQuery (this-object,pParentRow,pReq).                          
            end.         
            otherwise
                return new FilteredContext(this-object,pParentRow,pReq).        
        end case.    
        
    end method.
   
    method override protected IDataAdminCollection CreateCollection(pparent as char,cntxt as FilteredContext):     
        case pparent:
            when "tenants" then
            do:
                return new TenantSequenceValueMap(cntxt).                  
            end.                 
            when "sequences" then
            do:
                return new SequenceSequenceValueMap(cntxt).     
            end.         
            otherwise
                return super:CreateCollection(pparent,cntxt).        
        end case.    
        
    end method.
   
	method public override logical CanFind(name as character):
        undo, throw new UnsupportedOperationError("CanFind in SequenceValueContext. Use FilteredContext subclass to narrow down key" ).  
    end.    
    
    method public logical Find( seq as char,tenant as character):
        find ttsequenceValue where ttSequencevalue.SchemaName = SchemaName
                               and ttSequencevalue.SequenceName = seq 
                               and ttSequenceValue.TenantName = tenant 
                             no-error.
        return avail ttsequenceValue.                      
    end.    
    
    method public logical CanFind(pseq as char,ptenant as character):
        return can-find (ttsequenceValue where ttSequencevalue.SchemaName = SchemaName
                                           and ttSequencevalue.SequenceName = pseq
                                           and ttSequenceValue.TenantName = ptenant).
        
    end.    
     
    method public override logical Find(name as character):
        undo, throw new UnsupportedOperationError("Find in SequenceValueContext. Use FilteredContext subclass to narrow down key" ).  
    end.    
 
    method public override logical CanFind(i as int):
        undo, throw new UnsupportedOperationError("CanFind integer in SequenceValueContext" ).  
    end.    
     
    method public override logical Find(i as int):
        undo, throw new UnsupportedOperationError("Find integer SequenceValueContext." ).  
    end.    
    
    /* collection is handled in filteredcollection subclasses and should not reach here  */
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        undo, throw new UnsupportedOperationError("CreateCollection SequenceValueContext." ).  
    end method.
    
    method protected override IDataAdminElement CreateEntity(preq as IRequestInfo):
        return new SequenceValue(this-object,preq).       
    end method. 
    
    method public override character ColumnSource(pcColumn as char):
        define variable cField  as character no-undo.
        define variable cBuffer as character no-undo.
        
        define variable cMsg as character no-undo. 
        
        if num-entries(pcColumn,".") > 1 then
        do:
            cBuffer = entry(1,pcColumn,".").
            cField  = entry(2,pcColumn,".").
            if cBuffer = "Tenant" then
            do:
                return ContextFactory:TenantContext:ColumnSource(cField).
            end.  
            else if cBuffer = "sequence" then
            do:
                return ContextFactory:Sequencecontext:ColumnSource(cField).         
            end.      
        end.
        return super:ColumnSource(pcColumn).
    end method.
    
      
    /** DataRefreshed Override to handle requests that have retrieved sequence or tenant data for 
        join. Added in getRequest in FilteredContext query subclass */
    method public override void DataRefreshed(pResponse as IFetchResponse):
        define variable i as integer no-undo.
        define variable hBuffer  as handle no-undo.
        define variable ldone as logical no-undo.   
        
        if not mRefresh and pResponse:Entityname = "SequenceValue" then
        do:
            hBuffer = pResponse:DataHandle:get-buffer-handle ("ttSequence").
            if valid-handle(hBuffer) then
            do:    
                mRefresh = true. /* this will fire back here - avoid endless loop, 
                                    but ensure call to super below when it happens */
                ContextFactory:SequenceContext:DataRefreshed(pResponse). 
                ldone = true.
            end.
            else do:
                 /* redirect refresh to parent */
                hBuffer = pResponse:DataHandle:get-buffer-handle ("ttTenant").
                if valid-handle(hBuffer) then
                do:
                    mRefresh = true. /* this will fire back here - avoid endless loop */
                    ContextFactory:TenantContext:DataRefreshed(pResponse).       
                    ldone = true.
                end.
            end.
        end.
        if not ldone then 
        do:       
            super:DataRefreshed(pResponse).       
            mRefresh = false.
        end. 
     end method. 
end class.
