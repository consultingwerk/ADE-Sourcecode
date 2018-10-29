/************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ObjectArrayHolder
    Purpose     : OO holder for an array of objects
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.IObjectArrayHolder.

class OpenEdge.Core.ObjectArrayHolder implements IObjectArrayHolder:
    /* An array of obejcts to hold. */
    define public property Value as Progress.Lang.Object extent no-undo get. set. 
    
    /* Default constructor */
    constructor public ObjectArrayHolder():
        super ().
    end constructor.
    
    /* Constructor 
    
       @param Object[] An array of objects to 'hold' */
    constructor public ObjectArrayHolder(input pValue as Progress.Lang.Object extent):
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
                                (if valid-object(this-object:Value[iLoop]) then this-object:Value[iLoop]:ToString() else ?) )
                   cDelim = ',':u.
        end.
        
        return cValue.
    end method.
    
end class.