/*************************************************************/
/* Copyright (c) 2011-2014 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Query Partitions for a field 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2011
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.IRow from propath.
using OpenEdge.DataAdmin.Binding.PartitionContext from propath.
using OpenEdge.DataAdmin.Binding.Query.SchemaPartitionQuery from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using Progress.Lang.* from propath.

class OpenEdge.DataAdmin.Binding.Query.FieldPartitionQuery inherits SchemaPartitionQuery: 
	
	constructor public FieldPartitionQuery ( pdatacontext as PartitionContext, pRow as IRow,pReq as IRequestInfo):
	 	super (pdatacontext,pRow,pReq).
   	end constructor.
    

end class.