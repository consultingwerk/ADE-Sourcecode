/*************************************************************/
/* Copyright (c) 2010-2016 by progress Software Corporation   */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    File        : FieldContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :   2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.ISchemaScope.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.IndexContext.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.PartitionPolicyFieldContext.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.Query.IndexFieldQuery.
using OpenEdge.DataAdmin.Binding.Query.PartitionPolicyFieldQuery.
using OpenEdge.DataAdmin.Binding.Query.TableFieldQuery.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.FieldImpl.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.IFetchResponse.
using OpenEdge.DataAdmin.Support.IndexFieldSet.
using OpenEdge.DataAdmin.Support.PartitionPolicyFieldList.
using OpenEdge.DataAdmin.Support.TableFieldSet.
using Progress.Lang.*.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope from propath.


class OpenEdge.DataAdmin.Binding.FieldContext inherits DataAdminContext : 
    
    {daschema/field.i}
     
    define private dataset dsField serialize-name "root" for ttField.
    define buffer bField for ttField.
    define temp-table copyField reference-only like ttField .  
    define variable mpartitions as PartitionContext no-undo.
    define variable SchemaScope as ISchemaScope no-undo.  
    
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttField:handle.
    	end get.
    
     define public override property KeyFields as character  no-undo  
        get():
            return "TableName,Name". 
        end.    
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bField for ttField.
            if Count = ? then
            do:
                Count = 0.
                for each bField:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
    
    define private variable IndexContext  as IndexContext no-undo.
    
    constructor public FieldContext ():
        super ("Field").
    end constructor.
    
    constructor public FieldContext (pscope as ISchemaScope):
        super ("Field",pscope).
        SchemaScope = pscope.
    end constructor.
    
    constructor protected FieldContext (pname as char):
        super (pname).
    end constructor.
   
    constructor protected FieldContext (pname as char,pScope as ISchemaScope):      
        super (pname,pscope).
        SchemaScope = pscope.
   end constructor.
    
    method override protected void InitChildren (pscope as IContextScope):
        initChildren(cast(pScope,ISchemaScope)).
    end method.
    
    method protected void InitChildren (pscope as ISchemaScope):
        AddChild(pScope:PartitionContext).
        AddChild(pscope:PartitionPolicyFieldContext).
    end method.
            
    /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsField:handle. 
    end method.
    
    /* support lobFields as named query for collection */
    method override public character GetNamedQuery( pqname as character ):
        if pqname = "lobFields" then
            return "IsLob = " + quoter(true).
        return "".
    end method.
    
    /* support lobFields as named query for collection */
    method override public character GetNamedQueryName( pqname as character ):
        if pqname = "lobFields" then
            return "lobFields".
        return super:GetNamedQueryName(pqname).
    end method. 
       
	method public override void CopyTable(cntxt as IDataAdminModel).
        undo, throw new UnsupportedOperationError("Copy Schema").
    end method. 
     
    method public override void CreateRow(entity as IDataAdminElement):
        undo, throw new UnsupportedOperationError("Create Schema row").
    end method. 
	
    method public override character GetJoinFields(parentid as char):
        case parentid:
            when "tables" then 
                 return "name,TableName".
            when "indexes" then
                 return "TableName,TableName,name,IndexName".
            when "indexFields" then 
                 return "TableName,TableName,FieldName,Name".
             when "partitionPolicies" then
                 return "Name,PartitionPolicyName".
        end.
        return "".
    end.
    
    /* override default tree to not include child (partitions) */
    method override public void AddTreeTo( input tree as IContextTree,preq as IRequestInfo ):
        super:AddTableTo(input tree,pReq).
    end method.
     
	method public override logical CanFind(name as character):
        undo, throw new UnsupportedOperationError("CanFind with name in FieldContext").          
    end.    
     
    method public override logical Find(name as character):
        undo, throw new UnsupportedOperationError("Find with name in FieldContext").       
    end.   
    
    /** Find with unique key
         @param TableName  
         @param FieldName   */
    method public logical Find(ptablename as char,pname as character):
        find ttField where ttField.TableName = ptablename
                     and   ttField.Name = pname no-error.
        return avail ttField.             
    end.    
    
    /** CanFind on unique key
         @param TableName  
         @param FieldName   */
    method public logical CanFind(ptablename as char,pname as character):
        return can-find(ttField where ttField.TableName = ptablename
                                and   ttField.Name = pname).
    end.    
     
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        undo, throw new UnsupportedOperationError("CreateCollection in FieldContext").
        /* return new FieldSet(cntxt).*/
    end method.
    
    method protected override IDataAdminElement CreateEntity(pReq as IRequestInfo):
        return new FieldImpl(this-object,pReq).
    end method.
    
         /* support many-to-many to indexes (fields as child) */    
    method protected override IDataAdminModel GetNamedChild(pname as char):
        if pName = "indexes" then
        do:
            if not valid-object(IndexContext) then
            do:
                if valid-object(SchemaScope) then
                    IndexContext = SchemaScope:IndexContext.
            end.
            return IndexContext.
        end.
        else if pname = "indexFields" then 
        do:
           if valid-object(SchemaScope) then
                return SchemaScope:IndexFieldContext.
        end.     
        else if pname = "partitionPolicyFields" then 
        do:
           if valid-object(SchemaScope) then
                return SchemaScope:PartitionPolicyFieldContext.
        end.       
        
        return super:GetNamedChild(pname).
     
    end method. 
    
    method override protected FilteredContext CreateFilteredContext(pParentRow as IRow,pReq as IRequestInfo):
         
         case pParentRow:SerializeName:
             when "PartitionPolicies" then
             do:
                 return new PartitionPolicyFieldQuery(this-object,pParentRow,pReq).
             end.    
             when "tables" then
             do:              
                 if this-object:name eq "AllField" then
                     return new TableFieldQuery(this-object,pParentRow:KeyValues,pReq).
                 else return new TableFieldQuery(this-object,pParentRow:KeyValue,pReq).
             end.  
             when "indexes" then
             do:              
                 return new IndexFieldQuery(this-object,pParentRow:KeyValues,pReq).
             end.             
             otherwise
                 return super:CreateFilteredContext(pParentRow,pReq).              
         end.        
    end method.
    
    method public override character GetChildQuery(pparent as IRow ):
        define variable cQuery as character no-undo.
        
        case pparent:SerializeName:
            when "partitionPolicies" then
            do:
                cQuery = GetServerChildQuery(pparent) .
                cQuery = "preselect " + TrimQuery(cQuery).
                /* add the join for the client query */
                return cQuery + " where ttField.TableName = ttpartitionPolicyField.TableName"
                              + " and ttField.Name = ttpartitionPolicyField.FieldName by ttpartitionPolicyField.Number". 
            end.        
            when "indexes" then
            do:
                cQuery = GetServerChildQuery(pparent) .
                cQuery = "preselect " + TrimQuery(cQuery).
                /* add the join for the client query */
                return cQuery + " where ttField.TableName = ttIndexField.TableName"
                              + " and ttField.Name = ttIndexField.FieldName by ttIndexField.Number". 
            end.        
        end.    
        return super:GetChildQuery(pparent). 
        
    end method.
    
    method public override character GetServerChildQuery(pparent as IRow):
        define variable cQuery as character no-undo.
        
        case pparent:SerializeName:
            when "partitionPolicies" then
            do:
                return  "for each ttpartitionPolicyField where ttpartitionPolicyField.PartitionPolicyName "  
                            + " = "  + quoter(pparent:KeyValue ) 
                            + ", each ttField". 
            end.        
            when "indexes" then
            do:
                /* we manage the server relation in IndexFieldQuery:GetQueryRequest by defining a join between the
                   two tables in the request dataset    */  
                return  "for each ttIndexField where ttIndexField.TableName "  
                            + " = "  + quoter(pparent:KeyValues[1])
                            + " and ttIndexField.IndexName"
                            + " = "  + quoter(pparent:KeyValues[2])
                            + ", each ttField".
             end.    
         end. 
         return super:GetserverChildQuery(pparent). 
       
    end method.
    
    method public override handle extent GetQueryHandles(pcParent as char):
        define variable h as handle extent 2 no-undo.
        if pcParent = "indexes" then
        do: 
            h[1] = SchemaScope:IndexFieldContext:TableHandle:default-buffer-handle.
            h[2] = TableHandle:default-buffer-handle.
            return h.
        end.
        if pcParent = "partitionPolicies" then
        do: 
            h[1] = SchemaScope:PartitionPolicyFieldContext:TableHandle:default-buffer-handle.
            h[2] = TableHandle:default-buffer-handle.
            return h.
        end.
        else 
            return super:GetQueryHandles(pcParent). 
    end method.
    
    
    method override protected IDataAdminCollection CreateCollection(pparent as char,pcntxt as FilteredContext):     
         
        case pparent:
            when "tables" then
            do:          
                return new TableFieldSet(cast(pcntxt,TableFieldQuery)).
            end.   
            when "indexes" then
            do:          
                return new indexFieldSet(cast(pcntxt,IndexFieldQuery)).
            end. 
            when "partitionPolicies" then
            do: 
                return new PartitionPolicyFieldList(cast(pcntxt,PartitionPolicyFieldQuery)).
            end.    
            otherwise 
                 undo, throw new UnsupportedOperationError("CreateCollection for parent " + pparent + " in FieldContext").
             
        end.        
    end method.
    
     /** DataRefreshed Override to handle requests for indexfields  */
    method public override void DataRefreshed(pResponse as IFetchResponse):
        define variable i as integer no-undo.
        define variable hBuffer  as handle no-undo.
/*        define variable ldone as logical no-undo.*/
        
        if /*not mRefresh  and*/ pResponse:Entityname = "Field" then
        do:
            hBuffer = pResponse:DataHandle:get-buffer-handle ("ttIndexField").
            if valid-handle(hBuffer) then
            do:
/*                mRefresh = true. /* this will fire back here - avoid endless loop,      */
/*                                    but ensure call to super below when it happens */   */
                SchemaScope:IndexFieldContext:DataRefreshed(pResponse).
/*                ldone = true.                                                           */
            end.
        end.
/*        if not ldone then*/
/*        do:              */
        super:DataRefreshed(pResponse).       
/*            mRefresh = false.*/
/*        end.*/
     end method.
    
    
    
end class.
