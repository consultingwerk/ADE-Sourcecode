 /*************************************************************/
 /* Copyright (c) 2010 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : IndexContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :   2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Binding.DataAdminContext from propath.
using OpenEdge.DataAdmin.Binding.Factory.ISchemaScope from propath.
using OpenEdge.DataAdmin.Binding.FieldContext from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminModel from propath.
using OpenEdge.DataAdmin.Binding.IRow from propath.
using OpenEdge.DataAdmin.Binding.PartitionContext from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Binding.Query.PartitionPolicyIndexQuery from propath.
using OpenEdge.DataAdmin.Binding.Query.TableIndexQuery from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.IndexImpl from propath.
using OpenEdge.DataAdmin.Support.PartitionPolicyIndexSet from propath.
using OpenEdge.DataAdmin.Support.TableIndexSet from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.IndexContext inherits DataAdminContext implements IDataAdminContext: 
    
    {daschema/index.i}
     
    define private dataset dsIndex serialize-name "root" for ttIndex.
    define buffer bIndex for ttIndex.
    define temp-table copyIndex reference-only like ttIndex .  
    define variable mpartitions as PartitionContext no-undo.
      
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttIndex:handle.
    	end get.
     
    define public override property KeyFields as character  no-undo  
        get():
            return "TableName,Name". 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bIndex for ttIndex.
            if Count = ? then
            do:
                Count = 0.
                for each bIndex:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
        
    define private variable FieldContext as FieldContext no-undo.
    define private variable ContextFactory as ISchemaScope no-undo.
 
    
    constructor public IndexContext ():
        super ("Index").
        ExportWithRoot = false.
    end constructor.
    
    constructor public IndexContext (pscope as ISchemaScope):
        super ("Index",pscope).   
        AddChild(pscope:IndexFieldContext).
        AddChild(pscope:PartitionContext).
        ContextFactory = pscope.
        ExportWithRoot = false.
    end constructor.    
	        
    /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsIndex:handle. 
    end method.
    	
	/* override default tree to not include child (partitions) */
	method override public void AddTreeTo( input tree as OpenEdge.DataAdmin.Binding.IContextTree,pReq as IRequestInfo ):
		super:AddTableTo(tree,pReq).
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
            when "partitionPolicies" then 
                return "Name,PartitionPolicyName".
        end.
        return "".
    end.
    
    method public override character GetChildQuery(pParentrow as IRow):
        define variable cQuery as character no-undo.
        
        case pParentrow:SerializeName:
            when "partitionPolicies" then 
            do:
                cQuery = "preselect " + TrimQuery(GetServerChildQuery(pParentrow)).
                return cQuery + " where ttIndex.TableName = ttLocalIndex.TableName"
                                + " and  ttIndex.name = ttLocalIndex.IndexName". 
            end.        
        end case.
        return super:GetChildQuery(pParentrow).
    end.
    
    method public override character GetServerChildQuery(pParentrow as IRow):
        define variable cQuery as character no-undo.
        
        case pParentrow:SerializeName:
            when "partitionPolicies" then 
            do:
                return "for each ttLocalIndex where ttLocalIndex.PartitionPolicyName "  
                        +  " = "  + quoter(pParentrow:KeyValue ) 
                        +  ", each ttIndex". 
            end.        
        end case.
        return super:GetChildQuery(pParentrow).
    end.
    
    method public override handle extent GetQueryHandles(pcParent as char):
        define variable h as handle extent 2 no-undo.
        if pcParent = "partitionPolicies" then
        do: 
            h[1] = ContextFactory:LocalIndexContext:TableHandle:default-buffer-handle.
            h[2] = TableHandle:default-buffer-handle.
            return h.
        end.
        else 
            return super:GetQueryHandles(pcParent). 
    end method.
    
    /** Find with unique key
         @param TableName  
         @param IndexName   */
    method public logical Find(ptablename as char,pname as character):
        find ttIndex where ttIndex.TableName = ptablename
                     and   ttIndex.Name = pname no-error.
        return avail ttIndex.             
    end.    
    
    /** CanFind with unique key
         @param TableName  
         @param IndexName   */
    method public logical CanFind(ptablename as char,pname as character):
        return can-find(ttIndex where ttIndex.TableName = ptablename
                                and   ttIndex.Name = pname).
    end.    
       
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        undo, throw new UnsupportedOperationError("CreateCollection in IndexContext").
/*        return new IndexSet(cntxt).*/
    end method.
    
    method protected override IDataAdminElement CreateEntity(pReq as IRequestInfo):
         return new IndexImpl(this-object,pReq).
    end method.
       
     /* support many-to-many to fields (fields as child) */    
    method protected override IDataAdminModel GetNamedChild(pname as char):
        define variable i as integer no-undo.
        if pName = "fields" then
        do:
            if not valid-object(Fieldcontext) then
            do:
                if valid-object(ContextFactory) then
                    FieldContext = ContextFactory:FieldContext.
            end.
            return FieldContext.
        end.
        return super:GetNamedChild(pname).
    end method .
    
    method override protected FilteredContext CreateFilteredContext(pparent as IRow, pReq as IRequestInfo):     
         
         case pparent:SerializeName:
             when "tables" then
             do:              
                 return new TableIndexQuery(this-object,pparent:KeyValue,pReq).
             end. 
             when "partitionPolicies" then
             do:              
                 return new PartitionPolicyIndexQuery(this-object,pparent,pReq).
             end.              
             otherwise
                 return super:CreateFilteredContext(pparent,pReq).              
         end.        
    end method.
    
    method override protected IDataAdminCollection CreateCollection(pparent as char,pcntxt as FilteredContext):     
        case pparent:
            when "tables" then
            do:          
                return new TableIndexSet(cast(pcntxt,TableIndexQuery)).
            end.   
            when "partitionPolicies" then
            do:          
                return new PartitionPolicyIndexSet(cast(pcntxt,PartitionPolicyIndexQuery)).
            end.   
            otherwise 
                return super:CreateCollection(pparent,pcntxt).             
        end.        
    end method.
    
end class.
