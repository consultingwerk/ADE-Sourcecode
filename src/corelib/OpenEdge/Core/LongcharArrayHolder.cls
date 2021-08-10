/************************************************
Copyright (c) 2016, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LongcharArrayHolder
    Purpose     : OO holder for an array of character or long values 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharArrayHolder.
using OpenEdge.Core.Assert.

class OpenEdge.Core.LongcharArrayHolder implements ILongcharArrayHolder: 
    /* The longchar value being held */
    define public property Value as longchar extent no-undo get. set. 
    
    /* Constructor.
      
       @param integer The size of the array. Must be >0 */
    constructor public LongcharArrayHolder(input pSize as integer):
        super ().
        
        Assert:IsPositive(pSize, 'Array size').
        assign extent(this-object:Value) = pSize.
    end constructor.
    
    /* Default Constructor */
    constructor public LongcharArrayHolder ( ):
        super ().
    end constructor.

    /* Constructor
       
       @param longchar[] The Value array */
    constructor public LongcharArrayHolder (input pcValue as longchar extent):
        this-object().
        assign this-object:Value = pcValue.
    end constructor.

    /* Constructor
       
       @param character[] The Value array */
    constructor public LongcharArrayHolder (input pcValue as character extent):
        this-object().
        assign this-object:Value = pcValue.
    end constructor.
    
end class.