/*************************************************************/
 /* Copyright (c) 2011-2014 by progress Software Corporation. */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Query Indexes for a table 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.ContextTree from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Binding.IRow from propath.
using OpenEdge.DataAdmin.Binding.IndexContext from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.Message.FetchRequest from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using Progress.Lang.* from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.Query.TableIndexQuery inherits FilteredContext: 
	
	 
	/** Model may change so don't store this */   
    define private property IndexContext as IndexContext no-undo
        get():
            return cast(Model,IndexContext).   
        end.
        
	define protected variable TableName    as char        no-undo.
    
	constructor public TableIndexQuery ( pdatacontext as IndexContext, pcTable as character, pReq as IRequestInfo):
	 	super (pdatacontext,"tables", pcTable, pReq).
        TableName = pcTable.                           
	end constructor.
	
	/* Indexes for partitionpolicy (table is key - query islocal = true) */
	constructor protected TableIndexQuery ( pdatacontext as IndexContext, pcRow as IRow, pReq as IRequestInfo):
        super (pdatacontext,pcRow, pReq).
    end constructor.
    
    method public override logical CanFind(pName as char): 
        if IndexContext:Find(TableName,pName) then 
            return CanFindCurrentModel().
        return false.       
    end method.
    
    method public override logical Find(pName as char): 
        if IndexContext:Find(TableName,pName) then
            return SynchWithModel().
        return false.
    end method.
    
    method public override IFetchRequest GetQueryRequest():
        define variable tree   as IContextTree no-undo.
        define variable hds    as handle no-undo.
        define variable cQuery as character no-undo.
       
        tree = new ContextTree().
        AddTableTo(tree).
        
        hds = tree:GetReadHandle().
       
        return new FetchRequest(Name,Id,hds,no). 
    end method.
    
    
end class.