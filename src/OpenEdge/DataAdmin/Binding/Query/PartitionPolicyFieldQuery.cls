/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Used for a collection of PartionGroups for the tenant
                  indexed/mapped by PartionGroupName            
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Apr 18 22:12:27 EDT 2011 
                - date applies to some unknown original - many save-as has happened since...
       Notes    : tenantgroupContext is the main context since this is to be used 
                  by ItenantgroupSet collections with Itenantgroup elements. 
                - The PartitionPolicyFieldContext is used for add and remove
                  sonce it defines the many to many relation ship that is being updated.
                - The query joins these context tables. 
                - This query is added to ttPartitionPolicyField, but 
                  passed as tenant entityname, in the request.
                - There is an equivalent query to handle this from the other side;
                  tenantgroupTenantQuery 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.
using Progress.Lang.* from propath.
 
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IDataAdminElement  from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.IField from propath.
using OpenEdge.DataAdmin.Binding.IRow from propath.
using OpenEdge.DataAdmin.Binding.Query.ManyToManyQuery from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Binding.PartitionPolicyFieldContext from propath.
using OpenEdge.DataAdmin.Binding.FieldContext from propath.
using OpenEdge.DataAdmin.Binding.ContextTree from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Message.FetchRequest from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath.


routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.Query.PartitionPolicyFieldQuery inherits ManyToManyQuery: 
	define private var PolicyName as character no-undo.
	define private var TableName as character no-undo.
	
    /** UpdateContext(Model) may change so don't store this */   
    define private property PartitionPolicyFieldContext as PartitionPolicyFieldContext no-undo 
        get():
            return cast(UpdateContext,PartitionPolicyFieldContext).   
        end.
        
    constructor public PartitionPolicyFieldQuery (pparent as  FieldContext,policy as IRow,pReq as IRequestInfo):
		super (pparent,policy,"partitionPolicyFields",pReq).	
		Tablename = policy:FieldValue("TableName").
		/** not really necessary, but makes code more understandable */
		PolicyName = ParentValue.
		if TableName = "" then  
		    undo, throw new IllegalArgumentError("Cannot create Fields collection for a Partition Policy with no Table.").
	end constructor.
  
    method public override logical CanFind(pname as character):    
        if PartitionPolicyFieldContext:Find(PolicyName,TableName,pName) then 
             return CanFindCurrentModel(PartitionPolicyFieldContext).
        return false.    
    end.    
     
    method public override logical Find(pname as character):
        if PartitionPolicyFieldContext:Find(PolicyName,TableName,pName) then 
            return SynchWithModel(PartitionPolicyFieldContext). 
        return false.    
    end.    
    
    method public override integer IndexOf(pname as character):
        if PartitionPolicyFieldContext:Find(PolicyName,TableName,pName) then 
        do:
           if SynchWithModel(PartitionPolicyFieldContext) then
                return QueryHandle:current-result-row. 
        end.
        return 0.    
    end.    
    
    method public override logical Delete(pname as character):
        if PartitionPolicyFieldContext:Find(PolicyName,TableName,pName) then 
        do:
             return PartitionPolicyFieldContext:Delete(PolicyName,TableName,pName).
        end.
        return false.    
    end.    
    
    method public override IFetchRequest GetQueryRequest():
        define variable tree as IContextTree no-undo.
        define variable msg as IFetchRequest no-undo.
        define variable hds as handle no-undo.
        define variable cSeqValQuery as character no-undo.
        define variable cSequenceQuery as character no-undo.
        define variable qstr as QueryString no-undo.
        
        tree = new ContextTree().
        PartitionPolicyFieldContext:AddTableTo(tree).
        tree:SetJoin("PartitionPolicyFields",SerializeName,"TableName,TableName,FieldName,Name"). 
        AddTableTo(tree).
        hds = tree:GetReadHandle().
        msg = new FetchRequest(Name,Id,hds,no). 
      
        return msg.
                 
    end method.
    
    
    
end class.