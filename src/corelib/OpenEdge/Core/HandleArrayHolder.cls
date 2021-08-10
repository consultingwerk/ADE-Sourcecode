/************************************************
Copyright (c) 2016, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HandleArrayHolder
    Purpose     : OO holder for an array of handle values 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IHandleArrayHolder.
using OpenEdge.Core.Assert.

class OpenEdge.Core.HandleArrayHolder implements IHandleArrayHolder: 
    /* The value being held */
    define public property Value as handle extent no-undo get. set. 
    
    /* Constructor.
      
       @param integer The size of the array. Must be >0 */
    constructor public HandleArrayHolder(input pSize as integer):
        super ().
        
        Assert:IsPositive(pSize, 'Array size').
        assign extent(this-object:Value) = pSize.
    end constructor.
    
    /* Default Constructor */
    constructor public HandleArrayHolder (  ):
        super ().
    end constructor.
    
    /* Constructor
       
       @param handle[] The Value array */
    constructor public HandleArrayHolder(input pValue as handle extent):
        this-object().
        assign this-object:Value = pValue.
    end constructor.

end class.