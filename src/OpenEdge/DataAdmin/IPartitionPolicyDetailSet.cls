/*************************************************************/
/* Copyright (c) 2013,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : IPartitionPolicyDetailSet
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2013
    Notes       : 
  ----------------------------------------------------------------------*/
 
 
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetail  from propath.   
 

interface OpenEdge.DataAdmin.IPartitionPolicyDetailSet inherits IDataAdminCollection:  
  
    method public logical Add(newdetail as IPartitionPolicyDetail).
    method public logical Remove(detail as IPartitionPolicyDetail).
    method public logical CanFind(detailName as char).
    method public logical Contains(detail as IPartitionPolicyDetail).
   
    /**
     * 
     * @param  Name
     */
    method public IPartitionPolicyDetail Find(detail as char).
 
    
 
end interface.
