/************************************************
Copyright (c) 2016, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : RowidArrayHolder
    Purpose     : OO holder for an array of rowid values 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IRowidArrayHolder.
using OpenEdge.Core.Assert.

class OpenEdge.Core.RowidArrayHolder implements IRowidArrayHolder: 
    /* The value being held */
    define public property Value as rowid extent no-undo get. set. 
    
    /* Constructor.
      
       @param integer The size of the array. Must be >0 */
    constructor public RowidArrayHolder(input pSize as integer):
        super ().
        
        Assert:IsPositive(pSize, 'Array size').
        assign extent(this-object:Value) = pSize.
    end constructor.
    
    /* Default Constructor */
    constructor public RowidArrayHolder (  ):
        super ().
    end constructor.

    /* Constructor
       
       @param rowid[] The Value array */
    constructor public RowidArrayHolder(input pValue as rowid extent):
        this-object().
        assign this-object:Value = pValue.
    end constructor.

    method override public character ToString():
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cValue as character no-undo.
        define variable cDelim as character no-undo.
        
        assign iMax = extent(this-object:Value)
               cDelim = '':u. 
        do iLoop = 1 to iMax:
            assign cValue = substitute('&1&2&3':u,
                                cValue,
                                cDelim,
                                this-object:Value[iLoop])
                   cDelim = ',':u.
        end.
        
        return cValue.
    end method.

end class.