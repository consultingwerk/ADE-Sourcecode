/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : IContextFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Sep 13 17:51:00 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.IDataAdminService.
using Progress.Lang.*.

interface OpenEdge.DataAdmin.Binding.Factory.IContextScope:  
    define public property IsLocal as logical no-undo get.  
    define public property ServiceAdapter as ServiceAdapter no-undo get.  
    define public property Service as IDataAdminService no-undo get. 
     
    method public IDataAdminModel  GetContextBySerializeName(pname as char):
    
     
    method public IDataAdminModel GetContext(pname as char).
    
      /* allow implementers to allow joins for many to many for new objects 
       to use other context (service context) for the other end of the relation
       Defining it here releaves the caller from checking if context is local or not 
       as this can be called transparently */        
    method public IDataAdminModel GetLookupContext(pname as char):
          /* allow implementers to allow joins for many to many for new objects 
       to use other context (service context) for the other end of the relation
       Defining it here releaves the caller from checking if context is local or not 
       as this can be called transparently */        
    method public IDataAdminModel GetLookupContextBySerializeName(pname as char):
end interface.