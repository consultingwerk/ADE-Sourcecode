/*************************************************************/
/* Copyright (c) 2011,2013,2019 by Progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : DataSecurity
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw. 
 
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IDataDefinitionOptions.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDataAdminSerializable.
using OpenEdge.DataAdmin.IDataSecurity.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ITablePermissionSet.
using OpenEdge.DataAdmin.TablePermissionSet.
using Progress.Lang.Object.
class OpenEdge.DataAdmin.DataSecurity inherits Entity implements IDataSecurity, IDataAdminElement, IDataAdminSerializable:  
        
    define public property TablePermissions as ITablePermissionSet     no-undo 
        get():
            define variable h as handle no-undo.
            if not valid-object(TablePermissions) then
            do:
                TablePermissions = cast(GetChildCollection("tablePermissions"),ITablePermissionSet).
            end.
/*            if not mTablesLoaded then*/
/*                FetchTables().       */
            return TablePermissions.     
        end.
        protected set.
   
	constructor public DataSecurity ( cntxt as IDataAdminModel ):
		super (input cntxt).
	end constructor.
	
    constructor public DataSecurity ( cntxt as IDataAdminModel, pReq as IRequestInfo ):
        super (input cntxt).
    end constructor.	
    
	constructor public DataSecurity ( name as character ):
		super (input name).		
	end constructor.
    
    /* No local context needed - no child collections   */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
    
    method public void ExportLastSavedTree(pcFile as char). 
        this-object:context:ExportLastSavedTree(pcFile).  
    end method. 
   
    method public override void WriteTree(tree as IContextTree):
         Context:AddTreeTo(tree). 
    end method. 
  
 
end class.
