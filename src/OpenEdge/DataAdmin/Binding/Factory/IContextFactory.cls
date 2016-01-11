
/*------------------------------------------------------------------------
    File        : IServerContextFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Sep 13 18:03:56 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.Factory.*.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using Progress.Lang.*.
interface OpenEdge.DataAdmin.Binding.Factory.IContextFactory
                    inherits IAreaScope,
                             IMultiTenantScope, 
                             ISchemaScope, 
                             IIdentityScope:  
                                 
    /* wide name scope - serialize, context , physical db table*/   
    method public IDataAdminModel GetContextByAnyName(pname as char):
   
                                 
end interface.