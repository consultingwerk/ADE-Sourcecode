 /*************************************************************/
 /* Copyright (c) 2016 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : AllFieldContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Fri Mar 04 13:01:43 IST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Binding.FieldContext.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.AllFieldContext inherits FieldContext: 

	constructor public AllFieldContext ( input pScope as OpenEdge.DataAdmin.Binding.Factory.ISchemaScope ):
        super ("AllField",pScope).
    end constructor. 

    constructor public AllFieldContext (  ):
        super ("AllField").
        
    end constructor.

    method override protected handle CreateDataset( ):
        return CreateDataSet("").

    end method.
    
    method public override character GetJoinFields(parentid as char):
        case parentid:
            when "tables" then 
                 return "name,TableName,SchemaName,TableOwner".
            when "indexes" then
                 return "TableName,TableName,name,IndexName".
            when "indexFields" then 
                 return "TableName,TableName,FieldName,Name".
             when "partitionPolicies" then
                 return "Name,PartitionPolicyName".
        end.
        return "".
    end.

end class.