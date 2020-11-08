/************************************************
Copyright (c) 2016, 2019 by Progress Software Corporation. All rights reserved.
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
    method override public logical Equals(INPUT PO AS Progress.Lang.Object):
         define variable ocDec as OpenEdge.Core.Decimal no-undo.
         define variable valCompare as decimal no-undo.
         if super:Equals(PO) then
             return true.
         if type-of(PO, OpenEdge.Core.Decimal) then
         do:
             ocDec = cast(PO, OpenEdge.Core.Decimal).
             return 
                    this-object:Value = ocDec:Value.
         end.
         else 
         if type-of(PO, IDecimalHolder) then
         do:
           valCompare = dynamic-property(PO, 'Value').
           If this-object:Value eq valCompare then 
             return true.
         end.
         return false.
    end method.
end class.


