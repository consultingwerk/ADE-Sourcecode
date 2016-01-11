 /*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : DeallocateUtility
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Jul 12 17:00:21 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

routine-level on error undo, throw.

using OpenEdge.DataAdmin.ITenant from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.ITenantGroup from propath.
using OpenEdge.DataAdmin.Util.IDataAdminUtility from propath.
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.
using OpenEdge.DataAdmin.Message.DeallocateRequest from propath.

class OpenEdge.DataAdmin.Util.DeallocateUtility implements IDataAdminUtility: 
     define public property Tenant as ITenant no-undo get. private set. 
     define public property Table as ITable no-undo get. private set.
     define public property TenantGroup as ITenantGroup no-undo get. private set.
     define private variable mtype as character no-undo. 
    /*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	constructor public DeallocateUtility (pGroup as ITenantGroup  ):
        super ().
        this-object:TenantGroup = pGroup.
        this-object:Table = pGroup:Table.
        mtype = "group".         
    end constructor.
		
	constructor public DeallocateUtility (pTenant as ITenant, ptable as ITable  ):
		super ().
		this-object:Tenant = pTenant.
		this-object:Table = pTable.
		mtype = "tenant".		    
	end constructor.

    method public IUtilityRequest GetRequest():
        define variable msg as DeallocateRequest no-undo.
        assign 
            msg = new DeallocateRequest()
            msg:TableName = Table:name
            msg:Type = mtype
            msg:Name = if mtype = "tenant" then Tenant:name
                       else TenantGroup:name.
      
        return msg.
    end method.    
    
    method public void ImportOptions(cfile as char):
    end method.
end class.