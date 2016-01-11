/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : PartitionPolicyIndexQuery
    Purpose     : A sub query on local indexes. Create and Remove updates index.IsLocal. 
                  Adding an index to a collection used by this will make the index local
                  Removing it makes it global.    
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Feb 25 22:36:40 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.ContextTree from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Binding.IRow from propath.
using OpenEdge.DataAdmin.Binding.IndexContext from propath.
using OpenEdge.DataAdmin.Binding.LocalIndexContext from propath.
using OpenEdge.DataAdmin.Binding.Query.ManyToManyQuery from propath.
using OpenEdge.DataAdmin.Binding.Query.TableIndexQuery.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.IIndex from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath.
using OpenEdge.DataAdmin.Message.FetchRequest from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using Progress.Lang.*.

block-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.Query.PartitionPolicyIndexQuery inherits ManyToManyQuery: 
    
    define private var PolicyName as character no-undo.
    define private var TableName as character no-undo.
	 
	/** UpdateContext(Model) may change so don't store this */   
    define private property LocalIndexContext as LocalIndexContext no-undo 
        get():
            return cast(UpdateContext,LocalIndexContext).   
        end. 
           
	constructor public PartitionPolicyIndexQuery (pdatacontext as IndexContext, pPolicy as IRow, pReq as IRequestInfo ):
		super (pdatacontext,pPolicy,"localindexes",pReq).
		Tablename = pPolicy:FieldValue("TableName").
        /** not really necessary, but makes code more understandable */
        PolicyName = pPolicy:KeyValue.
        if TableName = "" then  
            undo, throw new IllegalArgumentError("Cannot create LocalIndex collection for a Partition Policy with no Table.").
	end constructor.

    method public override logical CanFind(pname as character):    
        if LocalIndexContext:Find(PolicyName,TableName,pName) then 
             return CanFindCurrentModel(LocalIndexContext).
        return false.    
    end.    
     
    method public override logical Find(pname as character):
        if LocalIndexContext:Find(PolicyName,TableName,pName) then 
            return SynchWithModel(LocalIndexContext). 
        return false.    
    end.    
    
    method public override integer IndexOf(pname as character):
        if LocalIndexContext:Find(PolicyName,TableName,pName) then 
        do:
           if SynchWithModel(LocalIndexContext) then
                return QueryHandle:current-result-row. 
        end.
        return 0.    
    end.   
     
    method public override logical Delete(pname as character):
        if LocalIndexContext:Find(PolicyName,TableName,pName) then 
        do:
             return LocalIndexContext:Delete(PolicyName,TableName,pName).
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
        LocalIndexContext:AddTableTo(tree).
      
        tree:SetJoin("LocalIndexes",SerializeName,"TableName,TableName,IndexName,Name"). 
        AddTableTo(tree).
        hds = tree:GetReadHandle().
        msg = new FetchRequest(Name,Id,hds,no). 
      
        return msg.
                 
    end method.
    
    
    
end class.