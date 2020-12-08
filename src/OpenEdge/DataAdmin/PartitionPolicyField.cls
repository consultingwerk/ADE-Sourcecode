/*************************************************************/
/* Copyright (c) 2013,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : interface for partition policy field 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2013
    Notes       : Not mapped directly to any data source  
                  This is exposing the field array in the partition policy in the database
----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Entity from propath.

using OpenEdge.DataAdmin.IPartitionPolicyField from propath.
using OpenEdge.DataAdmin.IPartitionPolicy from propath.
using OpenEdge.DataAdmin.IField from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminModel from propath.

class OpenEdge.DataAdmin.PartitionPolicyField inherits Entity implements IPartitionPolicyField  :      
    define public property Number           as int no-undo                   get.
    
    /** PartitionPolicyName character unique identifier - max length 32 */    
    define public property PartitionPolicy  as IPartitionPolicy no-undo   
        get():
            if not valid-object(this-object:Field) and valid-handle(mBuffer) and valid-object(Service) then
            do:
                 this-object:PartitionPolicy = service:GetPartitionPolicy(mBuffer::PartitionPolicyname). 
            end.
            return this-object:PartitionPolicy.
        end.
        set. 
    
    define public property Field as IField no-undo 
        get():
            if not valid-object(this-object:Field) and valid-handle(mBuffer) and valid-object(Service) then
            do:
                 this-object:Field = service:GetTable(mBuffer::Tablename):Fields:Find(mBuffer::FieldName). 
            end.
            return this-object:Field.
        end.
        set. 
       
    constructor public PartitionPolicyField (cntxt as IDataAdminModel):
        super (cntxt).     
    end constructor.
    
    constructor public PartitionPolicyField (pname as char):
        super (pname).     
    end constructor.
    
    constructor public PartitionPolicyField (cntxt as IDataAdminModel,preq as IRequestInfo):
        super (cntxt,preq).        
    end constructor.
        
    /**   local context needed - has child collections   */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
end class.