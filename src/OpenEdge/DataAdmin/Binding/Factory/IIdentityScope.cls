/***********************************************************************************
Copyright (c) 2011-2016,2023 by Progress Software Corporation. All rights reserved.
***********************************************************************************/
/*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Sep 13 12:33:09 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.Binding.* from propath.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope from propath.

interface OpenEdge.DataAdmin.Binding.Factory.IIdentityScope inherits IContextScope:   

    define public property AuthenticationSystemContext as AuthenticationSystemContext no-undo get.

    define public property AuthTagContext as AuthTagContext no-undo get.

    define public property DomainContext as DomainContext no-undo get.

    define public property GrantedRoleContext as GrantedRoleContext no-undo get.

    define public property RoleContext as RoleContext no-undo get.
      
    define public property TenantContext as TenantContext no-undo get.

    define public property UserContext as UserContext no-undo get.

end interface.