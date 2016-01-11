/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : request for proutil partitionmanage split
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Mar 18
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.
using OpenEdge.DataAdmin.Message.IUtilityResponse from propath.
using OpenEdge.DataAdmin.Message.PartitionManageRequest from propath.
using Progress.Lang.* from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Message.PartitionMergeRequest inherits PartitionManageRequest implements IUtilityRequest,IUtilityResponse : 
    define property SourceName as character no-undo get. set.
     /* identifier for the service adapter (directly to data access) */
    define public override property EntityName as character no-undo
        init "PartitionMerge" 
        get .
    
      
end class.