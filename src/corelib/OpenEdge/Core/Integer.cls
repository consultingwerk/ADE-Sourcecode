/************************************************
Copyright (c) 2016, 2019 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Assert.

class OpenEdge.Core.Integer implements IInt64Holder:
    define public property Value as int64 no-undo get. set.

    constructor public Integer(input piValue as int64):
        assign this-object:Value = piValue.
    end constructor.
    constructor public Integer(input piValue as integer):
        assign this-object:Value = piValue.
    end constructor.
    
    method override public logical Equals(INPUT PO AS Progress.Lang.Object):
         define variable ocInt as OpenEdge.Core.Integer no-undo.
         define variable valCompare as integer no-undo.
         if super:Equals(PO) then
             return true.
         if type-of(PO, OpenEdge.Core.Integer) then
         do:
             ocInt = cast(PO, OpenEdge.Core.Integer).
             return 
                    this-object:Value = ocInt:Value.
         end.
         else
         if type-of(PO, IInt64Holder) then
         do:
           valCompare = dynamic-property(PO, 'Value').
           If this-object:Value eq valCompare then 
             return true.
         end.
         return false.
    end method.
    method override public character ToString():
        return string(this-object:Value).
    end method.
end class.

