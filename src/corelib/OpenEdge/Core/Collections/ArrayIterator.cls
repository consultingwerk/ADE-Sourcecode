/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : ArrayIterator
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jun 14 12:13:12 EDT 2012
    Notes       : * Based on the AutoEdge|TheFactory version
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.Assert.

using Progress.Lang.Object.

class OpenEdge.Core.Collections.ArrayIterator implements IIterator:
    define protected property CurrentExtent as integer no-undo get. set.
    define protected property IteratedArray as Array no-undo  get. set .
    
    constructor public ArrayIterator(input poIteratedArray as Array):
        Assert:NotNull(poIteratedArray, 'Iterated Array').
        
        CurrentExtent = 0.
        IteratedArray = poIteratedArray.
    end method.
    
	method public logical HasNext():
		define variable lHasNext as logical no-undo.
		
		lHasNext = (CurrentExtent + 1) le IteratedArray:Size.
		
		return lHasNext.
	end method.

	method public Object Next():
	    define variable iGetExtent as integer no-undo.
	    
	    assign iGetExtent = CurrentExtent
	           CurrentExtent = CurrentExtent + 1.        
		return IteratedArray:GetValue(iGetExtent).
	end method.
	
	method public logical Remove():
        return IteratedArray:Remove(IteratedArray:GetValue(CurrentExtent)).
	end method.

end class.