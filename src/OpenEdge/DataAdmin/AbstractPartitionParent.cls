 /*************************************************************/
/* Copyright (c) 2013,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    File        : AbstractPartitionParent
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jul 18 2013
    Notes       : 
  ----------------------------------------------------------------------*/
  
routine-level on error undo, throw.
  
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IPartitionMap.
using OpenEdge.DataAdmin.IPartitionParent.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.*.

class  OpenEdge.DataAdmin.AbstractPartitionParent abstract inherits Entity implements IPartitionParent : 
    
    define protected property ValidDefaultAllocationList as char 
       init ?
       get():
           return GetValidDefaultAllocationList(). 
       end.
         
	define public abstract property DefaultAllocation as character no-undo 
	get.
	set. 

	define public abstract property DefaultDataArea as OpenEdge.DataAdmin.IArea no-undo 
	get.
	set. 

	define public abstract property DefaultIndexArea as OpenEdge.DataAdmin.IArea no-undo 
	get.
	set. 

	define public abstract property DefaultLobArea as OpenEdge.DataAdmin.IArea no-undo 
	get.
	set. 

	define public property Description as char no-undo         
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Description.
            else
                return Description. 
        end.
        set(pDescription as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::Description = pDescription.
            end.
            else
                Description = pDescription.
        end.  
        
    method protected char GetValidDefaultAllocationList(): 
        return "Immediate,Delayed,None".
    end method.
    
	constructor public AbstractPartitionParent ( input pname as character ):
		super (pname).
		
	end constructor.

		
	constructor public AbstractPartitionParent (  cntxt as IDataAdminModel, preq as  IRequestInfo ):
		super (cntxt, preq).
		
	end constructor.

		
	constructor public AbstractPartitionParent (  cntxt as IDataAdminModel ):
		super (cntxt).
		
	end constructor.

end class.