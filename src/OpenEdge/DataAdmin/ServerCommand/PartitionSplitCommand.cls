/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Wraps proutil partitionmanage split
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Mar 18
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Message.DeallocateRequest from propath.
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.
using OpenEdge.DataAdmin.Message.PartitionSplitRequest from propath.
using OpenEdge.DataAdmin.ServerCommand.ProutilCommand from propath.
using Progress.Lang.* from propath.
routine-level on error undo, throw.

class OpenEdge.DataAdmin.ServerCommand.PartitionSplitCommand inherits ProutilCommand: 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	constructor public PartitionSplitCommand ( databasename as char ):
		super (databasename).	
		PromptValue = "y".	
	end constructor.
    
    method protected override char GetRequestString(pRequest as IUtilityRequest).
        define variable split as PartitionSplitRequest no-undo.
        split = cast(pRequest,PartitionSplitRequest).
        /*  proutil db-name –C partitionmanage split table [table-name] 
        {partition [table-partition-name ] | composite “initial”} 
         [useindex index-name] [recs  numrecs]*/
        
        return "partitionmanage split table "
               + split:TableName  
               + (if split:IsComposite    then " composite " + quoter("initial")
                                          else " partition " +  split:Name)
               + (if split:IndexName > "" then " useindex " + split:IndexName else "")
               + (if split:NumRows > 0    then " recs " +  String(split:NumRows) else "")
               + (if session:cpinternal = "undefined":U then "" else " -cpinternal " + session:cpinternal)  
               + (if split:dbusername > "" then "-U " +  split:dbusername else "")
               + (if split:dbpassword > "" then "-P " +  split:dbpassword else "").
    end method.
    
end class.