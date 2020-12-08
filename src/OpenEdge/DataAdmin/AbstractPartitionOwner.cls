/*************************************************************/
/* Copyright (c) 2013,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    File        : AbstractPartitionOwner
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jul 18 01:56:50 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.AbstractPartitionParent.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IPartitionMap.
using OpenEdge.DataAdmin.IPartitionOwner.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.*.

class OpenEdge.DataAdmin.AbstractPartitionOwner inherits AbstractPartitionParent implements IPartitionOwner abstract: 
    
    define public property Id as int init ? no-undo             
    get():
        if valid-handle(mBuffer) then
            return mBuffer::id.
        else
            return Id.    
    end.
    
    define public property IsAllocated as logical no-undo          
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsAllocated.
            else
                return IsAllocated. 
        end.
        protected set(pIsAllocated as logical):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::IsAllocated = pIsAllocated.
            end.
            IsAllocated = pIsAllocated.
        end. 

    define public abstract property IsDataEnabled as logical no-undo  get. set.
        
    
    define public property Partitions as IPartitionMap no-undo  
    get():
        if not valid-object(Partitions) then
        do:
            if not valid-object(context:Service) and not valid-object(context:TargetService) then
                undo, throw new IllegalOperationError("Partitions are not available in a " + name + "  that is not newed, created or retrieved by a service.").  
            AssertPartitions().
            Partitions = cast(GetChildCollection("partitions"),IPartitionMap).
/*                Partitions:Tenant = this-object.*/
   
       end.     
       return Partitions.
    end.
    private set.
    
    constructor public AbstractPartitionOwner ( input pname as character ):
        super (pname).
        
    end constructor.

        
    constructor public AbstractPartitionOwner (  cntxt as IDataAdminModel, preq as  IRequestInfo ):
        super (cntxt, preq).
        
    end constructor.

        
    constructor public AbstractPartitionOwner (  cntxt as IDataAdminModel ):
        super (cntxt).
        
    end constructor.
    
   
	method protected abstract void AssertPartitions() .
    method public abstract logical Allocate(  ).
end class.