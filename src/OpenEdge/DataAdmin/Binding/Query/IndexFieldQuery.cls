/*************************************************************/
 /* Copyright (c) 2013 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Query IField entities for an index 
                  indexfields is used in query, but not exposed
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2013
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.IDataAdminElement  from propath.
using OpenEdge.DataAdmin.IRequestInfo  from propath.
using OpenEdge.DataAdmin.IField  from propath.
using OpenEdge.DataAdmin.Binding.IndexFieldContext from propath.
using OpenEdge.DataAdmin.Binding.FieldContext from propath.
using OpenEdge.DataAdmin.Binding.ContextTree from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Binding.Query.ManyToManyQuery from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Message.FetchRequest from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath. 

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.Query.IndexFieldQuery inherits ManyToManyQuery: 
	  
/*	/** Parent context (Model) may change so don't store this */   */
/*    define private property FieldContext as FieldContext no-undo*/
/*        get():                                                  */
/*            return cast(Parent,FieldContext).                   */
/*        end.                                                    */
/*                                                                */
       /** UpdateContext(Model) may change so don't store this */   
    define private property IndexFieldContext as IndexFieldContext no-undo 
        get():
            return cast(UpdateContext,IndexFieldContext).   
        end.     
    define private variable TableName    as char        no-undo.
    define private variable IndexName    as char        no-undo.
    
	constructor public IndexFieldQuery ( pdatacontext as FieldContext, pckeys as character extent, pReq as IRequestInfo):
	 	super (pdatacontext,"indexes", pckeys,"indexFields" ,pReq).
        TableName = pckeys[1].     
        IndexName =  pckeys[2]. 
        QueryHandle:query-prepare (LocalFilter).
	end constructor.
	
	
    method public override logical CanFind(pName as char): 
        if IndexFieldContext:Find(TableName,IndexName,pName) then 
            return CanFindCurrentModel().
        return false.       
    end method.
    
    method public override logical Find(pName as char): 
        if IndexFieldContext:Find(TableName,IndexName,pName) then
            return SynchWithModel().
        return false.
    end method.
    
     method public override logical Delete(pName as char): 
        if IndexFieldContext:Find(TableName,IndexName,pName) then
            return IndexFieldContext:Delete(TableName,IndexName,pName).
        return false.
    end method.
        
    /* the colletion should override Add to call this and avoid elem:Attach   */ 
    method public override void CreateRow (pelem as IDataAdminElement).
        define variable inst as IField no-undo.
        inst = cast(pelem,IField).
        IndexFieldContext:CreateRow(TableName,IndexName,inst:Name).
    end method.
    
    method public override IFetchRequest GetQueryRequest():
        define variable tree as IContextTree no-undo.
        define variable msg as IFetchRequest no-undo.
        define variable hds as handle no-undo.
        define variable qstr as QueryString no-undo.
        
        tree = new ContextTree().
        IndexFieldContext:AddTableTo(tree).
        /* the filter is currently used only for export,  
          also note that SetFilter expects an expression 
        tree:SetFilter(IndexFieldContext:SerializeName,Filter).
        */
        /* call setHandle directly to avoid filter (even if it is not used ) */  
        /*  AddTableTo(tree).*/
        tree:SetHandle(SerializeName,TableHandle:default-buffer-handle)  .
        
        tree:SetJoin(IndexFieldContext:SerializeName,SerializeName,GetJoinFields(IndexFieldContext:SerializeName)).
        hds = tree:GetReadHandle().
        msg = new FetchRequest(Name,Id,hds,no). 
        qstr = new QueryString(Filter ).
        return msg.     
        finally:
            delete object qstr no-error.        
        end finally. 
    
    end method.
    
end class.