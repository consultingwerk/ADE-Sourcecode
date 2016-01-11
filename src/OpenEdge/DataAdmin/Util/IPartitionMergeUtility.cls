/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*-----------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2014
    Notes       : 
  ----------------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IPartitionPolicyDetail from propath.
using OpenEdge.DataAdmin.Util.IPartitionManageUtility from propath.

interface OpenEdge.DataAdmin.Util.IPartitionMergeUtility inherits IPartitionManageUtility: 
     define public property SourcePartitionPolicyDetail as IPartitionPolicyDetail no-undo get.  set. 
    
end interface.