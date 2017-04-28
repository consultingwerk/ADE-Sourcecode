/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LogicalValue
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jun 06 12:27:33 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILogicalHolder.

class OpenEdge.Core.LogicalValue implements ILogicalHolder:
    define public property Format as character no-undo get. set.
    
    define public property Value as logical  no-undo get.
        private set.
        
    constructor public LogicalValue(input plVal as logical):
        assign this-object:Value = plVal
               this-object:Format = 'yes/no':u.
    end constructor.

    method override public character ToString():
        return trim(string(this-object:Value, this-object:Format)).
    end method.
        
end class.