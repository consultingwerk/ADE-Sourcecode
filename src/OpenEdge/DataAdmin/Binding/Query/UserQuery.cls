/*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Query for Users
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Apr 2012
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.UserContext.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IUser.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.*.
class OpenEdge.DataAdmin.Binding.Query.UserQuery inherits FilteredContext: 
	
	/** Parent context (Model) may change so don't store this */
	define protected property UserContext as UserContext no-undo
	    get():
	        return cast(Model,UserContext).
	    end.
  
    constructor public UserQuery (sourcecntxt as IDataAdminModel,pfilter as char):
        super (sourcecntxt,pfilter).      
    end constructor.
    
    constructor public UserQuery (sourcecntxt as IDataAdminModel,pReq as IRequestInfo):
        super(sourcecntxt,pReq).
    end constructor.
    
    constructor public UserQuery (sourcecntxt as IDataAdminModel,pcparent as char,pcKeyvalue as char):
        super(sourcecntxt,pcParent,pcKeyValue). 
    end constructor.
    
	constructor protected UserQuery (pSource as IDataAdminModel, pcParent as char, pcKeyValue as char,pReq as IRequestInfo ):
		super (pSource,pcParent,pcKeyValue,pReq).	    
	end constructor.
    
    method public override character ColumnSource(pcColumn as char):
        if pccolumn = "TenantName" then 
             pcColumn = "Tenant.Name". 
        return super:ColumnSource(pcColumn).
    end method.
    
    method public override character ColumnSortSource(pcColumn as char):
         if pccolumn = "TenantName" then 
             pcColumn = "Tenant.Name". 
        return super:ColumnSortSource(pcColumn).
    end method.
    
end class.