
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
using OpenEdge.DataAdmin.Binding.PermissionContext.
using OpenEdge.DataAdmin.Binding.SchemaChanges.
using OpenEdge.DataAdmin.Binding.UserFieldPermissionContext.
using OpenEdge.DataAdmin.Binding.UserTablePermissionContext.
using Progress.Lang.*.

interface OpenEdge.DataAdmin.Binding.Factory.IServiceContextFactory inherits IContextFactory,  ISecurityScope: 
                            
    define public property PermissionContext as PermissionContext no-undo get.  
     
    method public IDataAdminModel GetLocalContext(pname as char):   
    method public IDataAdminModel GetLocalContextByAnyName(pname as char):     
    method public UserTablePermissionContext GetUserTablePermissionContext().  
    method public UserFieldPermissionContext GetUserFieldPermissionContext().  
     
    method public SchemaChanges GetSchemaDefinitionContext(pcfile as char).
end interface.