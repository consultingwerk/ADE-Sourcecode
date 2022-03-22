/************************************************
Copyright (c) 2016, 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LogicalArray
    Purpose     : Object wrapper around an array of ABL logical primitive values
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Wed Jun 08 21:05:28 EDT 2016
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILogicalArrayHolder.
using Progress.Lang.Object.

class OpenEdge.Core.LogicalArray
serializable
implements ILogicalArrayHolder:
    
    /* Property to hold the value. Immutable; can only be set via constructor*/
    define public property Value as logical extent no-undo get. private set.
    
    /* Constructor
       
       @param logical[] An array of values. May be indeterminate. */
    constructor public LogicalArray(input plVal as logical extent):
        assign this-object:Value = plVal.
    end constructor.
    
    @since(rel='12.5.0').
    method public override logical Equals(input pObj as Object):
        var integer loop, cnt = extent(this-object:Value).
        var ILogicalArrayHolder lah.
        
        if not valid-object(pObj) then
            return false.
        
        // it's being compared to itself
        if int64(pObj) eq int64(this-object) then
            return true.
        
        // Must be of the correct type
        if not type-of(pObj, ILogicalArrayHolder) then
            return false.
            
        assign lah = cast(pObj, ILogicalArrayHolder).
        
        // size and values must match exactly
        if not cnt eq extent(lah:Value) then
            return false.
        
        do loop = 1 to cnt:
            if not this-object:Value[loop] eq lah:Value[loop] then
                return false.
        end.
        
        return true.
    end method.
    
end class.