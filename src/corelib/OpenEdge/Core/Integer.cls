/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Integer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jun 03 13:54:42 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IInt64Holder.

class OpenEdge.Core.Integer implements IInt64Holder: 

    define public property Value as int64 no-undo get. set.
        
    constructor public Integer(input piValue as int64):
        assign this-object:Value = piValue.
    end constructor.

    constructor public Integer(input piValue as integer):
        assign this-object:Value = piValue.
    end constructor.

    method override public character ToString():
        return string(this-object:Value).
    end method.
    
end class.