/*************************************************************/
/* Copyright (c) 2011,2013 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    File        : LocaContextFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Sep 13 23:54:43 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/


routine-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.Factory.AbstractContextFactory.
using OpenEdge.DataAdmin.Binding.Factory.IServiceContextFactory.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.NewPartitionContext.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.IDataAdminService.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.Factory.LocalContextFactory inherits AbstractContextFactory: 
    
    define protected property ServiceFactory as IServiceContextFactory no-undo get. set.
    
    /* override in local context to allow joins for many to many for new objects 
       to use service for the other end of the relation  */        
    method public override IDataAdminModel GetLookupContext(pname as char):
        return ServiceFactory:GetContext(pname).
    end method.
    
    /* override in local context to allow joins for many to many for new objects 
       to use service for the other end of the relation  */        
    method public override IDataAdminModel GetLookupContextBySerializeName(pname as char):
        return ServiceFactory:GetContextBySerializeName (pname).
    end method.
    
	define override public property IsLocal as logical no-undo 
	init true
	get.
	  
	define public override property PartitionContext as PartitionContext no-undo 
        get(): 

             if not valid-object(PartitionContext) then
             do:
                 PartitionContext = new NewPartitionContext(this-object).
             end.
             return PartitionContext.
         end.
         set.
    
	constructor public LocalContextFactory ( pServiceFactory as IServiceContextFactory ):
		super (pServiceFactory:Service, pServiceFactory:ServiceAdapter).	
	    ServiceFactory = pServiceFactory.
	    Service:ServiceDeleted:Subscribe(this-object:Destroy). 
	end constructor.
    
    method protected void Destroy().
        delete object this-object.
    end method.
    
end class.