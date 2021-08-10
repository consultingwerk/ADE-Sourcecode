/* *************************************************************************************************************************
Copyright (c) 2016, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrArrayHolder
    Purpose     : OO holder for an array of datetime values 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IMemptrArrayHolder.
using OpenEdge.Core.Assert.

class OpenEdge.Core.MemptrArrayHolder implements IMemptrArrayHolder: 
    /* The value being held */
    define public property Value as memptr extent no-undo get. set. 
    
    /* Constructor.
      
       @param integer The size of the array. Must be >0 */
    constructor public MemptrArrayHolder(input pSize as integer):
        super ().
        
        Assert:IsPositive(pSize, 'Array size').
        assign extent(this-object:Value) = pSize.
    end constructor.
    
    /* Default Constructor */
    constructor public MemptrArrayHolder (  ):
        super ().
    end constructor.
    
    /* Constructor
       
       @param memptr[] The Value array */
    constructor public MemptrArrayHolder(input pValue as memptr extent):
        this-object().
        assign this-object:Value = pValue.
    end constructor.

end class.