/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : interface for tenant (data source _tenant)
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jun 10 00:01:21 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
 
 
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.IPartitionOwner from propath.
using OpenEdge.DataAdmin.ISequenceValueMap from propath.
using OpenEdge.DataAdmin.IPartitionMap from propath.
using OpenEdge.DataAdmin.ITenantGroupMemberSet from propath.
using OpenEdge.DataAdmin.ITenantGroupSet from propath.
using OpenEdge.DataAdmin.IDomainSet from propath.
using OpenEdge.DataAdmin.IUserSet from propath.

 
interface OpenEdge.DataAdmin.ITenant inherits IPartitionOwner :  
      
    /** Type tenant type is a character property with 
         valid values Regular,Super or Default  */    
    define public property Type as character no-undo           get. set.
    
    /** ExternalId an external character Id populated by owner 
        - no enforcement of unique  */    
    define public property ExternalID as char no-undo          get. set.
    
    /** SequenceValues ISequenceValueMap collection of the multi-tenant sequence 
        values ISequenceValue elements for the tenant mapped by ISequence       */                    
    define public property SequenceValues  as ISequenceValueMap no-undo      get.
     
    /** TenantGroups ITenantGroupSet with all partition groups (ITenantGroup) of the tenant
        belongs to */                    
    define public property TenantGroups as ITenantGroupSet no-undo get.
    
    /** TenantGroupMembers ITenantGroupMemberSet property with all partition group details
        (ITenantGroupMember) of the tenant. The ITenantGroupMember element on this currently only has the ITenant 
        and ITenantGroup keys and does thus not provide any information that you 
        cannot get using the TenantGroups property */                    
    define public property TenantGroupMembers as ITenantGroupMemberSet no-undo get.
    
    /** Domains IDomainSet of the domains (IDomain) of the tenant - read-only  */                    
    define public property Domains as IDomainSet no-undo get.  
    
    /** Users IUserSet of the users (IUser) of the tenant  - read-only
        Note: the users can also be accessed through the IDomain elements returned 
        by the Domains property. */                    
    define public property Users as IUserSet no-undo get.          
  
end interface.