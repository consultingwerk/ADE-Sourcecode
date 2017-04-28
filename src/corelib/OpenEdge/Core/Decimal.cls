/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Decimal
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jun 06 12:27:33 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDecimalHolder.

class OpenEdge.Core.Decimal implements IDecimalHolder:
    define public property Value as decimal  no-undo get.
        private set.
        
    constructor public Decimal (input pdVal as decimal):
        assign this-object:Value = pdVal.
    end constructor.        

    method override public character ToString():
        return string(this-object:Value).
    end method.

end class.