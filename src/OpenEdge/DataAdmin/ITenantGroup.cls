/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jun 10 00:01:21 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
 
using OpenEdge.DataAdmin.IPartitionOwner from propath.
using OpenEdge.DataAdmin.IPartitionMap from propath.
using OpenEdge.DataAdmin.ITenantGroupMemberSet from propath.
using OpenEdge.DataAdmin.ITenantSet from propath.
using OpenEdge.DataAdmin.ITable     from propath.
using OpenEdge.DataAdmin.IArea     from propath.
 
interface OpenEdge.DataAdmin.ITenantGroup  inherits IPartitionOwner:
     
    /** The Table of the group */
    define public property Table                 as ITable               no-undo get. set.
     
    /** Tenants ITenantSet with the tenants that belongs to the group. */ 
    define public property Tenants               as ITenantSet           no-undo get.
    
    /** TenantGroupMembers ITenantGroupMemberSet property with all partition group details
        (ITenantGroupMember) of the group. The ITenantGroupMember element on this currently only has the ITenant 
        and ITenantGroup keys and does thus not provide any information that you 
        cannot get using the Tenants property */                    
    define public property TenantGroupMembers as ITenantGroupMemberSet no-undo get.
    
      
end interface.