/************************************************
Copyright (c) 2013, 2016-2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : WidgetHandle
    Purpose     : Primitive class for widget-handle variables    
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 19 09:47:07 EDT 2011
    Notes       : * This class based on the AutoEdge|TheFactory version
                  * By default the handle will not be destroyed/deleted. Set 
                    the AutoDestroy property to TRUE to cleanup automatically.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IHandleHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.WidgetHandle.
using Progress.Collections.IComparable.
using Progress.Lang.Object.

class OpenEdge.Core.WidgetHandle serializable
        implements IHandleHolder,
           // Compare to the interface so that other implementations of IHandleHolder can be sorted with this one
           IComparable<IHandleHolder>:
             
    define public property Value as handle no-undo get. private set.
    
    /** Indicates whether the handle will be destroyed/cleared when this object
        is destroyed. Default is FALSE. */
    define public property AutoDestroy as logical initial false no-undo get. set.
    
    constructor public WidgetHandle():
        this-object(?).
    end constructor.

    destructor public WidgetHandle():
        if     AutoDestroy 
           and valid-object(this-object:Value ) then
            delete object this-object:Value no-error.
    end destructor.
    
    constructor public WidgetHandle(input phValue as handle):
        this-object(phValue, false).
    end constructor.

    constructor public WidgetHandle(input phValue as handle,
                                    input plAutoDestroy as logical):
        super().
        
        Assert:NotUnknown(plAutoDestroy, 'Auto destroy').
        assign this-object:AutoDestroy = plAutoDestroy
               this-object:Value       = phValue.
    end constructor.

    method override public logical Equals(input p0 as Object):
        if type-of(p0, WidgetHandle) then
            return (this-object:Value eq cast(p0, WidgetHandle):Value).
        else
            return super:Equals(p0).
    end method.
    
    method override public character ToString():
        define variable cValue as character no-undo.
        cValue = string(this-object:Value).
        
        return cValue.
    end method.

    /* Comparison method, used by SortedSet's default comparer
        
        - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
        - If the returned value equals 0 (zero) , then the current object occupies the same position in the sort order.
        - If the returned value is greater than 0(zero), then the current object sorts after the object passed in.
        - If either object's Value is the unknown value (?), then that sorts high/early/before
        
        @param IHandleHolder The object to compare to.
        @return integer  0 = same object
                        +1 = sorts after
                        -1 = sorts before   */
    method public integer CompareTo(input pOther as IHandleHolder):
        var longchar tochar, pochar.
        var character x, y.
        Assert:NotNull(pOther, 'CompareTo object').

        if this-object:Value eq pOther:Value then
            return 0.
        else
        // unknown values sort first/lower
        if this-object:Value gt pOther:Value
        or pOther:Value eq ?
        then
            return +1.
        else
        if this-object:Value lt pOther:Value
        or this-object:Value eq ?
        then
            return -1.
        
        // this will raise an error in the Comparer; we should never get here though.
        return ?.
            
    end method.
    
end class.
