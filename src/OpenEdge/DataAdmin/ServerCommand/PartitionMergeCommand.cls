/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Wraps proutil partitionmanage merge
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Mar 18
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Message.DeallocateRequest from propath.
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.
using OpenEdge.DataAdmin.Message.PartitionMergeRequest from propath.
using OpenEdge.DataAdmin.ServerCommand.ProutilCommand from propath.
using Progress.Lang.* from propath.
routine-level on error undo, throw.

class OpenEdge.DataAdmin.ServerCommand.PartitionMergeCommand inherits ProutilCommand: 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	constructor public PartitionMergeCommand ( databasename as char ):
		super (databasename).	
		PromptValue = "y".	
	end constructor.
    
    method protected override char GetRequestString(pRequest as IUtilityRequest).
        define variable merge as PartitionMergeRequest no-undo.
        merge = cast(pRequest,PartitionMergeRequest).
        /*  PROUTIL db-name -C PARTITIONMANAGE MERGE TABLE table-name 
            PARTITION partition-name1 PARTITION partition-name2 
            [PARTITION partition-name3 ] [useindex index-name] [recs numrecs] */
        
        return " partitionmanage merge table "
               + merge:TableName  
               + (if merge:FromSourceName > "" then " partition " + merge:FromSourceName else "")
               + (if merge:ToSourceName > "" then " partition " + merge:ToSourceName else "")
               + (if merge:TargetDetail > "" then " partition " + merge:TargetDetail else "")
               + (if merge:IndexName > "" then " useindex" + merge:IndexName else "")
               + (if merge:NumRows > 0    then " recs " +  String(merge:NumRows) else "")
               + (if session:cpinternal = "undefined":U then "" else " -cpinternal " + session:cpinternal)
               + (if merge:dbusername > "" then "-U " +  merge:dbusername else "")
               + (if merge:dbpassword > "" then "-P " +  merge:dbpassword else "").
    end method.
    
     
    
end class.