/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Array
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jun 14 11:35:49 EDT 2012
    Notes       : * Based on the AutoEdge|TheFactory version 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.ArrayIterator.
using OpenEdge.Core.Collections.ResizeError.
using OpenEdge.Core.Assert.

using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.Array serializable 
        implements ICollection:
    
    /* only ever used for ToTable() */
    define static private temp-table ttArray no-undo
        field ObjIndex as integer
        field ObjRef as Object
        index idx1 as primary unique ObjIndex.
    
    define public static variable DefaultArraySize as integer no-undo.
    
    /* Keep incrementally growing array Size as new elements are added. AutoExpanded
       ararys will grow by 50% of the current size each time. 
       
       This will negatively impact performance. */
    define public property AutoExpand as logical no-undo get. set.
    
    /* If true, we'll discard stuff off the bottom of the stack if
       we resize the stack smaller than its contents. */
    define public property DiscardOnShrink as logical no-undo get. set.
    
    define protected property Value as Object extent no-undo get. private set.
    
    define public property Size as integer no-undo
        get():
            return extent(this-object:Value).
        end.
        set(input piSize as integer):
            SetArraySize(piSize).
        end.
    
    constructor static Array():
        Array:DefaultArraySize = 10.
    end constructor.
    
    constructor public Array(input piSize as integer):
        assign Size = piSize
               AutoExpand = false
               DiscardOnShrink = false.
    end constructor.

    constructor public Array(input poArray as Object extent):
        this-object(extent(poArray)).
        this-object:AddArray(poArray).
    end constructor.
    
    constructor public Array():
        this-object(Array:DefaultArraySize).
    end constructor.
    
    method private void SetArraySize(input piNewSize as integer):
        define variable oTempObject as Object extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        /* do nothing if there's nothing to do */
        if piNewSize eq ? then
        do:
            if not DiscardOnShrink then
                undo, throw new ResizeError('Array', 'smaller'). 
            extent(this-object:Value) = piNewSize.            
        end.
        else
        if piNewSize ne this-object:Size then
        do:
            if piNewSize lt this-object:Size and not DiscardOnShrink then
                undo, throw new ResizeError('Array', 'smaller'). 
            
            /* if this is an indeterminate array, then do nothing */
            if this-object:Size eq ? then
                assign iMax = 0.
            else
                assign extent(oTempObject) = this-object:Size
                       oTempObject = this-object:Value
                       iMax = this-object:Size
                       extent(this-object:Value) = ?.
            extent(this-object:Value) = piNewSize.
            
            /* On init this loop won't execute */
            do iLoop = 1 to iMax:
                SetValue(oTempObject[iLoop], iLoop).
            end.
        end.
    end method.
    
    method public void SetValue(input poValue as Object):
        SetValue(poValue, (this-object:Size + 1)).
    end method.

    method public Object GetValue(input piExtent as integer):
        Assert:NotNullOrZero(piExtent, 'Extent').
        return this-object:Value[piExtent].
    end method.
    
    method public void SetValue(input poValue as Object,
                                input piExtent as integer):
        
        /* Expand array, if allowed and needed */
        if piExtent gt this-object:Size then
        do:
            if AutoExpand then            
                SetArraySize(integer(piExtent + round(0.5 * this-object:Size, 0))).
            else
                undo, throw new ResizeError('Array','larger').
        end.
        
        this-object:Value[piExtent] = poValue.
    end method.
    
    /* ICollection */
    method public logical Add(input o as Object):
        SetValue(o).
        return true.
    end method.

    method public logical AddAll(input c as ICollection):
        return AddArray(c:ToArray()).
    end method.

    method public logical AddArray(input c as Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iStartSize as integer no-undo.
        
        iMax = extent(c).
        /* manually resize the array, don't auto-increment */
        iStartSize = this-object:Size.
        SetArraySize(iStartSize + iMax).
        do iLoop = 1 to iMax:
            SetValue(c[iLoop], iStartSize + iLoop).
        end.
        
        return true.
    end method.

    method public void Clear():
        SetArraySize(?).
    end method.
    
    method public logical Contains( input o as Object):
        define variable lContainsArgument as logical no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        iMax = this-object:Size.
        do iLoop = 1 to iMax while not lContainsArgument:
            lContainsArgument = this-object:Value[iLoop]:Equals(o).
        end.
        
        return lContainsArgument.
    end method.
    
    /** Returns true if this list contains all of the elements of the
        specified collection.
        
        @param ICollection The collection of obejcts to check
        @return logical True if all the elements match */
    method public logical ContainsAll(input poCollection as ICollection).
        define variable oIterator as IIterator.
        define variable oCheck as Object. 
        define variable lAny as logical no-undo.
        
        assign oIterator = poCollection:Iterator()  
               lAny = false.
        do while oIterator:HasNext():
            oCheck = oIterator:Next().
            lAny = this-object:Contains(oCheck).
            if not lAny then
                leave.               
        end.
        
        return lAny.
    end method.   

    method public IIterator Iterator( ):
        define variable oArrayIterator as IIterator no-undo.
        return new ArrayIterator(this-object).
    end method.

    method public logical IsEmpty(  ):
        return (this-object:Size eq ?).
    end method.

    method public logical Remove( input o as Object ):
        define variable lRemoved as logical no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        iMax = this-object:Size.
        do iLoop = 1 to iMax while not lRemoved:
            if this-object:Value[iLoop]:Equals(o) then
                assign this-object:Value[iLoop] = ?
                       lRemoved = true.
        end.
        
        return lRemoved.
    end method.
    
    method public logical RemoveAll( input c as ICollection):
        define variable oIterator as IIterator.
        define variable oRemove  as Object. 
        define variable lAny as logical no-undo.
        
        oIterator = c:Iterator().
        do while oIterator:HasNext():
            oRemove = oIterator:Next().
            do while this-object:Remove(oRemove):
                lAny = true.
            end.
        end.
        
        return lAny.
    end method.

    method public logical RetainAll( input oCollection as ICollection ):
        define variable oIterator as IIterator no-undo.
        define variable oChild as Object no-undo.  
        define variable lAny as logical no-undo.
        
        oIterator = Iterator().
        do while oIterator:HasNext():
            oChild = oIterator:Next().
            if not oCollection:Contains(oChild) then 
            do:
                do while Remove(oChild):
                    lAny = true.
                end.
            end.     
        end.                                     
        return lAny.     
    end method.

    method public void ToTable( output table-handle tt):
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        empty temp-table ttArray.
        iMax = this-object:Size.
        do iLoop = 1 to iMax:
            create ttArray.
            assign ttArray.ObjIndex = iLoop
                   ttArray.ObjRef = this-object:Value[iLoop]. 
        end.
        
        tt = temp-table ttArray:handle.
    end method.
    
    method public Object extent ToArray():
        return this-object:Value.
    end method.
    
    /* Deep clone. or rather deep enough since we don't know what the elements' Clone()
       operations do, so this may end up being a memberwise clone */
    method override public Object Clone():
        define variable oClone as ICollection no-undo.
        
        oClone = cast(this-object:GetClass():New(), ICollection).
        CloneElements(oClone).
        
        return oClone.        
    end method.
    
    method protected void CloneElements(input poClone as ICollection):
        define variable oIterator as IIterator no-undo. 

        oIterator = this-object:Iterator().
        do while oIterator:HasNext():
           poClone:Add(oIterator:Next():Clone()).
        end.
    end method.
    
end class.
