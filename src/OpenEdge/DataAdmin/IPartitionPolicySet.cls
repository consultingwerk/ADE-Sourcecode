/*************************************************************/
/* Copyright (c) 2011,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : IPartitionPoliciySet
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2013
    Notes       : 
  ----------------------------------------------------------------------*/
 
 
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IPartitionPolicy  from propath.   
 

interface OpenEdge.DataAdmin.IPartitionPolicySet inherits IDataAdminCollection:  
  
    method public logical Add(newpolicy as IPartitionPolicy).
    method public logical Remove(policy as IPartitionPolicy).
    method public logical CanFind(policy as char).
    method public logical Contains(policy as IPartitionPolicy).
     
    /**
     * 
     * @param groupName
     */
    method public IPartitionPolicy Find(policy as char).
 
    /**
     * 
     * @param groupId
     */
 
end interface.
