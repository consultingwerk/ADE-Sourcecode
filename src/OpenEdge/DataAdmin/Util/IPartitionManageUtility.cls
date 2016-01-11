/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation.      */
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
    Created     : 2014
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IIndex from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetail from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.Util.IDataAdminUtility from propath.

interface OpenEdge.DataAdmin.Util.IPartitionManageUtility inherits IDataAdminUtility: 
     define public property PartitionPolicyDetail as IPartitionPolicyDetail no-undo get.  set. 
     define public property Table as ITable no-undo get.  set.
     define public property Index as IIndex no-undo get.  set.
     define public property TransactionSize as int no-undo get.  set.
     
end interface.