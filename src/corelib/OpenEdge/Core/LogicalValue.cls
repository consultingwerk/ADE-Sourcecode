/************************************************
Copyright (c) 2016, 2019 by Progress Software Corporation. All rights reserved.
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
    method override public logical Equals(INPUT PO AS Progress.Lang.Object):
         define variable ocLV as OpenEdge.Core.LogicalValue no-undo.
         define variable valCompare as logical no-undo.
         if super:Equals(PO) then
             return true.
         if type-of(PO, OpenEdge.Core.LogicalValue)  then
         do:
             ocLV = cast(PO, OpenEdge.Core.LogicalValue).
             return 
                    this-object:Value = ocLV:Value.
         end.
         else
         if type-of(PO, ILogicalHolder) then
         do:
           valCompare = dynamic-property(PO, 'Value').
           If this-object:Value eq valCompare then 
             return true.
         end.
         return false.
    end method.
end class.

